# Quick question: "Who knows how to create their own timer function?"

reactive_timer <- function() {
  start_time <- Sys.time()
  
  return(function() {
    return(Sys.time() - start_time)
  })
}

# Calling this function will start the timer, and it will return a function that we can use to check how much time has elapsed since the timer started.
timer <- reactive_timer()

timer()

# This timer function contains it's own state, and it gives us a function that we can call to return the state value.
# Reactive state is similarly related to this, but it introduces the idea of stateful values being inter-connected.

# How do variables work?

a_number <- 123

a_number

a_number <- 456

a_number

# Good. So, can we combine variables?

quote_1 <- "Oh don't lean on me man"

quote_2 <- "Cause you can't afford the ticket"

paste(quote_1, quote_2)

combined_string <- paste(quote_1, quote_2)

combined_string

# OK; so, that works. But what happens if we update one of the variables that went into the combined one?

quote_2 <- "Cause you ain't got time to check it"

quote_2

# Will the combined string reflect the new value of quote_2?
combined_string

# So; how can we make the combined variable always reflect the value of it's dependent variables?

# By using a function!

combined_string <- function(first_quote, second_quote) {
  return(paste(first_quote, second_quote))
}

print(combined_string(quote_1, quote_2))

# That's all a little verbose though...
# So why not make use of the global scope, and avoid having to pass so many arguments around?

combined_string <- function() {
  return(paste(quote_1, quote_2))
}

quote_1 <- "I'm an alligator"

combined_string()

quote_2 <- "I'm the space invader"

combined_string()

# That's how variables can be made to always reflect the current values of the variables that they use.

# The syntax of being forced to call the variables as a function is a bit ugly though, so let's see what we can do to avoid having to do that.

total_users <- NULL
new_users <- 1200

state <- c(
  function() {
    total_users <<- sum(total_users, new_users)
  }
)

total_users

state[[1]]()

total_users

# WooHoo!!

# But let's clean it up slightly...

# The function below will map through any (and all) state variables, running them, so that we don't have to manually run each one like we did with state[[1]]() above.

set_state <- function() {
  purrr::map(state, function(run) {
    run()
  })
}

new_users <- 2000

set_state()

total_users

# Ideally though, we wouldn't have to call set_state() to update the state.
# We'd like the setting of a new value to new_users to automatically trigger the update of state.

# Never actually directly update these variables.
total_users <- 0
new_users <- 1200

state <- c(
  function() {
    total_users <<- sum(total_users, new_users)
  }
)

set_state <- function() {
  purrr::map(state, function(run) {
    run()
  })
}

update_new_users <- function(value) {
  new_users <<- value

  set_state()
}

# initialize_state
set_state()

# Check value of total_users
total_users

# Add a new batch of users
update_new_users(2000)

# Check value of total_users
total_users

# Add more users
update_new_users(5500)

# Check value of total_users
total_users
