package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

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

	// Database connection string from environment variables
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		dbHost, dbPort, dbUser, dbPassword, dbName)

	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Initialize table if it doesn't exist
	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS site_stats (id serial PRIMARY KEY, views integer)`)
	if err != nil {
		log.Printf("Error creating table: %v", err)
	}

	// Ensure at least one row exists
	_, err = db.Exec(`INSERT INTO site_stats (id, views) SELECT 1, 0 WHERE NOT EXISTS (SELECT 1 FROM site_stats WHERE id = 1)`)
	if err != nil {
		log.Printf("Error initializing stats row: %v", err)
	}

	// Persistent Counter Endpoint
	http.HandleFunc("/api/count", func(w http.ResponseWriter, r *http.Request) {
		var current int
		// Atomic increment and fetch
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
		if err := db.Ping(); err != nil {
			w.WriteHeader(http.StatusServiceUnavailable)
			fmt.Fprintf(w, "db connection error: %v", err)
			return
		}
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "ok")
	})

	log.Printf("Starting server on port %s...", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
