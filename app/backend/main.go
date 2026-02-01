package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"sync"
)

type CounterResponse struct {
	Count int `json:"count"`
}

var (
	count int
	mu    sync.Mutex
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Simple Counter Endpoint
	http.HandleFunc("/api/count", func(w http.ResponseWriter, r *http.Request) {
		mu.Lock()
		count++
		current := count
		mu.Unlock()

		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*") // Enable CORS for the frontend
		json.NewEncoder(w).Encode(CounterResponse{Count: current})
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "ok")
	})

	log.Printf("Starting server on port %s...", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
