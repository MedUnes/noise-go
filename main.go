package main

import (
	"fmt"
)

func getMessage() string {
	return "ZzzzzZZzz"
}

func main() {
	message := getMessage()
	fmt.Printf("%s\n", message)
}
