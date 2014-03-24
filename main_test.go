package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestResponse(t *testing.T) {

	request, _ := http.NewRequest("GET", "/", nil)
	response := httptest.NewRecorder()

	handler(response, request)

	if response.Code != http.StatusOK {
		t.Fatalf("Expected 200, got %v", response.Code)
	}
	if response.Body.String() != "Hello World\n" {
		t.Fatalf("Non-expected response body:\n\tbody: %v", response.Body)
	}
}
