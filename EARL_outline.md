# Intermediate Shiny Workshop - EARL Sept 2016

Outline for the 1-day **Intermediate Shiny** workshop at [EARL 2016](https://earlconf.com/london/) in London, UK in September 2016.

## Outline

### Morning: Shiny essentials

- 10 - 11:00 am - Part 1: A fast introduction to Shiny (01_fast_intro)
- 11 - 12:00 am - Part 2: Reactive programming (02_reactive_prog)

### Afternoon: Increasing performance

- 12:00 - 1:00 pm - Part 1: Advanced reactivity
	- Stop/let reactions with isolate() and observeEvent()
		- used before observeEvent()
		- isolate -> blacklist
		- observeEvent -> whitelist -- took over isolate
		- necessary for reactivePoll() and reactiveFileReader()
		- observeEvent -> what you need to know
		- isolate -> under the hood, to understand why observeEvent is useful
	- Performance considerations:
		+ Schedule with invalidateLater()
			- nothing re-executes until a reactive value changes
			- used when user doesn't change input but other things have changed (like times passed)
				- now <- reactive({ invalidateLater(1000); Sys.time() })
					- no repetition (reactiveTimer does this but not useful)
		+ reactivePoll() and reactiveFileReader()
			- invalidateLater but based on file change
			- reactiveFileReader = invalidate when file changed (but that's not how it's built)
	- Reactivity best practices and observers
		- exercise think about it: reactives are equivalent to no argument functions, so don't think about them as functions, think about them as variables that can depend on user input and other reactives
		- take a look at shiny-discuss

- 1 - 2:00 pm Lunch

- 3 - 4:00 pm - Part 2: Modules
	- writing individual module is easy
	- how do you combine modules? how do you have input of module 1 depend on module 2? what if you want to show custom ui in the middle of a module?
		- think about how you would do this with functions, answer is you don't, don't violate the sanctity of function's local environment
		- what N principles to follow so you never make mistakes
- 2 - 3:00 pm - Part 3: Bookmarkable state
	- paper notes
- 4 - 4:15 pm - Q&A with Joe OR Bookmarkable state preview
- 4:15 - 5:00 pm - 45 minutes of Morning and Afternoon breaks, which will fall earlier in the day at awkward times


- if input is changing very rapidly: https://gist.github.com/jcheng5/6141ea7066e62cafb31c

- higher order reactives -- take in a reactive and return a reactive, but change how it works along the way