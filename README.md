# Transaction State Simulator for Order Book Data

The `state_at_date.foo` function is an R utility designed to simulate and track the daily state of transactions based on an order book. By leveraging the power of the `tidyverse` package, it provides tidy and efficient processing of transaction data, making it easy to calculate key metrics such as open positions, cash balance, investments, and performance.

## Features

- **Tidyverse Integration:** Built on the `tidyverse` package for seamless data manipulation and tidy processing.
- **Dynamic State Updates:** Handles various transaction scenarios, including no-change cases, buying, and selling operations.
- **Comprehensive Tracking:** Calculates open positions, cash flow, total investments, and cumulative performance in real time.
- **Flexible for Simulations:** Supports iterative processing of transactions to simulate and analyze financial states over time.

## Requirements

- **R version:** 4.0 or higher
- **Dependencies:** The function requires the `tidyverse` package for its functionality.

Install the `tidyverse` package if it is not already installed:

```R
install.packages("tidyverse")
```

## Usage

1. Clone or download this repository.
2. Source the `state_at_date.R` file into your R environment:

   ```R
   source("state_at_date.R")
   ```

## Contributions

We welcome contributions to improve the functionality, optimize performance, or extend the capabilities of this function. Here's how you can contribute:

1. **Report Issues**: If you encounter bugs or have suggestions for improvement, please open an issue in the repository.

2. **Submit Pull Requests**: Fork the repository, make your changes, and submit a pull request. Ensure that your code is well-documented and adheres to tidyverse coding principles.

3. **Share Feedback**: Whether it's about the functionality, documentation, or usability, your feedback helps us improve.

By contributing, you help enhance this tool for the community. Thank you for your support!



