package main

import (
	"testing"
)

func TestGetMessage(t *testing.T) {
	expected := "ZzzzzZZzz"
	message := getMessage()

	if message != expected {
		t.Errorf("Expected message to be %s, but got %s", expected, message)
	}
}
