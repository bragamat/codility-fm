package solution_2

import "fmt"

// Helper function to calculate the sum of digits of a number
func sumOfDigits(n int) int {
	sum := 0
	for n > 0 {
		sum += n % 10
		n /= 10
	}
	return sum
}

// Function to calculate the N-th element of the sequence
func solution(N int) int {
	if N == 0 {
		return 0
	}
	if N == 1 {
		return 1
	}

	// Initialize the first two elements of the sequence
	sequence := []int{0, 1}

	// Compute up to the N-th element
	for i := 2; i <= N; i++ {
		next := sumOfDigits(sequence[i-1]) + sumOfDigits(sequence[i-2])
		sequence = append(sequence, next)
	}

	return sequence[N]
}

func main() {
	// Test cases
	fmt.Println(solution(2))    // Output: 1
	fmt.Println(solution(6))    // Output: 8
	fmt.Println(solution(10))   // Output: 10
	fmt.Println(solution(100))  // Output: Computed value
	fmt.Println(solution(1000)) // Output: Computed value
}
