package solution_3

//final answer - WITH CONCURRENCY

// you can also use imports, for example:
// import "fmt"
// import "os"
// you can write to stdout for debugging purposes, e.g.
// fmt.Println("this is a debug message")

import (
	"fmt"
	"sync"
)

// sumOfDigits calculates the sum of all digits of a given number n.
// For example, sumOfDigits(123) = 1 + 2 + 3 = 6.
func sumOfDigits(n int) int {
	sum := 0
	for n > 0 {
		sum += n % 10
		n /= 10
	}
	return sum
}

// Solution computes the N-th element of the sequence
// by leveraging cycle detection and concurrency for improved performance.
// It handles large values of N by detecting and utilizing the repeating cycle in the sequence.
func Solution(N int) int {
	// Handle base cases directly
	if N == 0 {
		return 0
	}
	if N == 1 {
		return 1
	}

	// Initialize the sequence with the first two elements
	sequence := []int{0, 1}
	// Use a map to track pairs of consecutive numbers and their indices
	// This helps in detecting cycles efficiently
	seen := make(map[[2]int]int) // Map to detect cycles
	seen[[2]int{0, 1}] = 1

	// A channel for communicating the cycle information (start and length)
	results := make(chan int) // Buffered for exactly two results: cycleStart and cycleLength
	var wg sync.WaitGroup
	// Compute the sequence in a separate goroutine
	wg.Add(1)
	go func() {
		defer wg.Done()
		for i := 2; ; i++ {
			// Compute the next number in the sequence
			next := sumOfDigits(sequence[i-1]) + sumOfDigits(sequence[i-2])
			// Check for a cycle
			pair := [2]int{sequence[i-1], next}
			if index, exists := seen[pair]; exists {
				// Cycle detected: send the cycle info and stop
				results <- index
				results <- i - index
				return
			}
			// Update sequence and map
			sequence = append(sequence, next)
			seen[pair] = i
		}
	}()
	// Wait for the results from the goroutine
	var cycleStart, cycleLength int
	go func() {
		cycleStart = <-results
		cycleLength = <-results
		close(results)
	}()
	wg.Wait()
	// Use cycle to compute result
	if N < cycleStart {
		return sequence[N]
	}
	return sequence[cycleStart+(N-cycleStart)%cycleLength]
}

func main() {
	// Test cases
	fmt.Println(Solution(2))    // Output: 1
	fmt.Println(Solution(6))    // Output: 8
	fmt.Println(Solution(10))   // Output: 10
	fmt.Println(Solution(100))  // Output: Efficiently calculated value
	fmt.Println(Solution(1000)) // Output: Efficiently calculated value
}
