package main

import (
	"log"
	"net/http"

	"github.com/sagolubev/go-server/myserver"
)

const addr = "0.0.0.0:8080"

func main() {
	mux := http.NewServeMux()
	handler := &myserver.MyHandler{}
	mux.Handle("/favicon.ico", http.NotFoundHandler())
	mux.Handle("/", handler)
	log.Printf("Now listening on %s...\n", addr)
	server := http.Server{Handler: mux, Addr: addr}
	log.Fatal(server.ListenAndServe())

}
