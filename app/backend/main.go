package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/rds/auth"
	_ "github.com/lib/pq"
)

type CounterResponse struct {
	Count int `json:"count"`
}

var db *sql.DB

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	dbUser := os.Getenv("DB_USER")
	dbName := os.Getenv("DB_NAME")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	region := os.Getenv("AWS_REGION")

	var password string
	var err error

	// Use IAM authentication if DB_IAM_AUTH is set to "true"
	if os.Getenv("DB_IAM_AUTH") == "true" {
		log.Println("Using IAM authentication for database...")
		cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
		if err != nil {
			log.Fatalf("failed to load configuration, %v", err)
		}

		authenticationToken, err := auth.BuildAuthToken(
			context.TODO(),
			fmt.Sprintf("%s:%s", dbHost, dbPort),
			region,
			dbUser,
			cfg.Credentials,
		)
		if err != nil {
			log.Fatalf("failed to build auth token, %v", err)
		}
		password = authenticationToken
	} else {
		log.Println("Using static password authentication for database...")
		password = os.Getenv("DB_PASSWORD")
	}

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=require",
		dbHost, dbPort, dbUser, password, dbName)

	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Initialize table and row (Note: In IAM mode, the user must have CREATE permissions)
	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS site_stats (id serial PRIMARY KEY, views integer)`)
	if err != nil {
		log.Printf("Note: Table check/creation skipped or failed (common if IAM user has limited perms): %v", err)
	}

	_, err = db.Exec(`INSERT INTO site_stats (id, views) SELECT 1, 0 WHERE NOT EXISTS (SELECT 1 FROM site_stats WHERE id = 1)`)
	if err != nil {
		log.Printf("Note: Stats row check skipped or failed: %v", err)
	}

	http.HandleFunc("/api/count", func(w http.ResponseWriter, r *http.Request) {
		var current int
		err := db.QueryRow(`UPDATE site_stats SET views = views + 1 WHERE id = 1 RETURNING views`).Scan(&current)
		if err != nil {
			log.Printf("DB Error: %v", err)
			http.Error(w, "Database error", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		json.NewEncoder(w).Encode(CounterResponse{Count: current})
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		if db != nil {
			if err := db.Ping(); err != nil {
				log.Printf("DB Ping failed: %v", err)
			}
		}
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "ok")
	})

	log.Printf("Starting server on port %s...", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
