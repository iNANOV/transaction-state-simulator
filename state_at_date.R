library(tidyverse)

# Function to update the state at a given date based on transactions
# Parameters:
# - acc [result at t-1]: A list representing the previous state, including:
#        - open_positions: Data frame of current positions (id, Close, price).
#        - investment: Total investment value in current positions.
#        - cash: Remaining acumulated cash balance.
#        - performance: Performance of all current positions (t - (t-1))/(t-1).
# - curr [variable at t]: A character string representing the transaction in the format "Close_amount_price".
# - initial_cash [constant]: Numeric value representing the initial cash amount available for transactions.
# Returns [result at t]: 
# - A list with updated state components: open_positions, investment, cash, and performance.

state_at_date.foo <- function(acc, curr, initial_cash) {
  # Parse the current transaction string into a data frame
  t <- tibble(value = curr) %>%
    separate(
      col = value,
      into = c("Close", "amount", "price"), # Split into Close, amount, and price
      sep = "_"
    ) %>%
    mutate(across(everything(), as.numeric)) # Convert all columns to numeric
  
  # Check for initial state (empty or NULL accumulator)
  if (length(acc) == 0 || is.null(acc[[1]]) || nrow(acc[[1]]) == 0) {
    # Initial case: First transaction
    res <- list(
      open_positions = data.frame(
        id = seq_len(t$amount), # Generate IDs for positions
        Close = t$Close,
        price = t$price
      ),
      investment = t$price * t$amount, # Calculate initial investment
      cash = initial_cash - t$price * t$amount, # Update cash balance
      performance = (t$Close - t$price) * t$amount # Calculate initial performance
    )
  } else {
    # Handle subsequent transactions
    
    # Case 1: No change (amount is NA)
    if (is.na(t$amount)) {
      open_positions_0 <- acc$open_positions %>%
        mutate(Close = t$Close) # Update Close values for all positions
      
      res <- list(
        open_positions = open_positions_0,
        investment = acc$investment,
        cash = acc$cash,
        performance = open_positions_0 %>%
          mutate(return = Close - price) %>%
          pull(return) %>% sum() # Sum up the returns for performance
      )
    }
    
    # Case 2: Sell positions (amount < 0)
    else if (t$amount < 0) {
      open_positions_0 <- acc$open_positions %>%
        mutate(id = row_number()) %>% # Recrate ID column in order to reset it
        select(-Close) %>% # Remove old Close column 
        left_join(
          data.frame(
            id = seq_len(abs(t$amount)), # Generate IDs for positions to be closed
            Close = t$price * -1
          ),
          by = "id"
        )
      
      res <- list(
        open_positions = filter(open_positions_0, is.na(Close)) %>%
          mutate(Close = t$Close),
        investment = filter(open_positions_0, is.na(Close)) %>%
          pull(price) %>% sum(),
        cash = filter(open_positions_0, !is.na(Close)) %>%
          pull(Close) %>% sum() * -1 + acc$cash,
        performance = filter(open_positions_0, is.na(Close)) %>%
          mutate(Close = t$Close) %>%
          mutate(return = Close - price) %>%
          pull(return) %>% sum()
      )
    }
    
    # Case 3: Buy positions (amount > 0)
    else if (t$amount > 0) {
      open_positions_0 <- acc$open_positions %>%
        mutate(Close = t$Close) %>% # Update Close for all positions
        bind_rows(
          data.frame(
            id = seq_len(t$amount), # Add new positions
            Close = t$Close,
            price = t$price
          )
        )
      
      res <- list(
        open_positions = open_positions_0,
        investment = acc$investment + t$amount * t$price,
        cash = acc$cash - t$amount * t$price,
        performance = open_positions_0 %>%
          mutate(return = Close - price) %>%
          pull(return) %>% sum()
      )
    }
  }
  
  # Return the updated state
  return(res)
}
