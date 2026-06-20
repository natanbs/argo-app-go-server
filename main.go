package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, `{"status": "ok"}`)
}

func osHandler(w http.ResponseWriter, r *http.Request) {
	osRelease, _ := os.ReadFile("/etc/os-release")
	memory, _ := exec.Command("free", "-m").Output()
	cpus, _ := exec.Command("getconf", "_NPROCESSORS_ONLN").Output()

	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	fmt.Fprintf(w, "=== /etc/os-release ===\n%s\n", osRelease)
	fmt.Fprintf(w, "=== free -m ===\n%s\n", strings.TrimSpace(string(memory)))
	fmt.Fprintf(w, "=== CPUs ===\n%s\n", strings.TrimSpace(string(cpus)))
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from Go server on port 8090!\n")
	})
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/os", osHandler)
	log.Println("Go server listening on :8090")
	log.Fatal(http.ListenAndServe(":8090", nil))
}
