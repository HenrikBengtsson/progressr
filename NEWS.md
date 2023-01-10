# Version 0.13.0 [2023-01-09]

## Significant Changes

 * Now the 'shiny' and 'filesize' handlers are enabled by
   default. Previously, they were only enabled in interactive mode,
   but as these are frequently used also in non-interactive mode, it's
   less confusing if they're always enabled, e.g. Shiny applications
   are often run via a Shiny servers. These handlers can be disabled
   by setting R option `progressr.enable` to FALSE.
   
 * Option `progressr.intrusiveness.auditory` has been renamed to
   `progressr.intrusiveness.audio`.

## New Features

 * Add `handler_rpushbullet()` for reporting on progress via the
   Pushbullet Messaging Service using the **RPushbullet** package.
   
 * Now also 'beepr', 'debug', 'filesize', 'notifier', 'rpushbullet',
   'shiny', 'tkprogressbar', and 'winprogressbar' handlers report on
   interrupts.
   
 * Now progress updates of type "finish" supports also updating the
   progress state, e.g. you can do `p(amount = 1.0, type = "finish")`
   whereas previously you had to do `p(amount = 1.0)` and then `p(type
   = "finish")` resulting in two progress conditions being signaled.

## Bug Fixes

 * When using multiple progression handlers, it would only be first one
   that was updated as the progressor completed, whereas any following
   ones would not receive that last update.
 
 * The 'cli' handler would output a newline when completed.
 
 * The 'cli' handler did not handle zero-length progressors resulting
   in `Error in rep(chr_complete, complete_len) : invalid 'times'
   argument` when the progressor completed.
   
 * The 'cli' handler did not work when the **cli** package was
   configured to report on progress via **progressr**, i.e. when
   setting `options(cli.progress_handlers = "progressr")`.


# Version 0.12.0 [2022-12-12]

## Significant Changes

 * Now `with_progress()` and `without_progress()` disables the global
   progress handler temporarily while running to avoid progress
   updates being handled twice.  Previously, it was, technically,
   possible to have two different progress handlers intertwined.

## New Features

 * Add `handler_cli()` for rendering progress updates via the **cli**
   package and its `cli::cli_progress_bar()`.
   
 * Now `handler_progress()` creates a **progress** progress bar that
   is always rendered by forcing `progress::progress_bar$new(...,
   force = TRUE)`.
   
 * `handler_txtprogressbar()` gained support for ANSI-colored `char`
   ASCII and Unicode symbols.

## Miscellaneous

 * Now `with_progress()` asserts that the number of active "output"
   sinks is the same on exit as on enter, and that the last one closed
   is the one that was created.  If not, an informative error message
   is produced.

 * Now all progress handlers assert that the number of active "output"
   sinks is the same on exit as on enter.
   
 * Code that relied on the superseded **crayon** package has now been
   updated to use the **cli** package.

## Bug Fixes

 * Using `with_progress()` while the global progress handler was
   enabled could result in errors for the **cli** handler, and
   possibly for other progression handlers developed in the future.
   Because of this, `with_progress()` and `without_progress()` now
   disables the global progress handler temporarily while running.

 * The `pbmclapply()` handler went from 0 to 100% in one step, because
   we forgot to set the `max`:imum value.
 

# Version 0.11.0 [2022-09-02]

## New Features

 * When the using a 'winprogressbar' or a 'tkprogressbar' handler,
   progression messages updates the `label` component of the progress
   panel.  Now, it is also possible to update the `title` component
   based on progression messages.  How the `title` and `label`
   components are updated and from what type of progression message is
   configured via the new `inputs` argument.  For example, `inputs =
   list(title = "sticky_message", label = "message")` causes
   progression messages to update the `label` component and sticky
   ones to update both.  For backward compatible reasons, the default
   is `inputs = list(title = NULL, label = "message")`.

 * Now the demo function `slow_sum()` outputs also "sticky" messages.
 
## Miscellaneous

 * Avoid nested `<em>` tags in HTML-generated help pages.


# Version 0.10.1 [2022-06-02]

## New Features

 * Now **plyr** (>= 1.8.7) supports **progressr** for also parallel
   processing, e.g. `y <- plyr::llply(X, slow_sum, .parallel = TRUE,
   .progress = "progressr")`.

## Bug Fixes

 * The 'plyr' progress plugin stopped working with **progressr**
   0.8.0.

 * Warnings on stray `progression` conditions could appear with an
   empty message.
 

# Version 0.10.0 [2021-12-18]

## Significant Changes

 * Now interrupts are detected, which triggers the progress handlers
   to terminate nicely, e.g. a progress bar in the terminal will stay
   as-is instead of being cleared.

## Bug Fixes

 * A progressor that signaled progress beyond 100% prevented any
   further progressors in the same environment to report on progress.
   
 * It was not possible to reuse handlers of type 'progress' more than
   once, because they did not fully reset themselves when finished.

 * The 'pbcol' progression handler did not respect `clean = FALSE`.

## Deprecated and Defunct

 * Function `progress()` is defunct in order to re-use it for other
   purpose.  It is unlikely that anyone really used this function, but
   if you did, then use `cond <- progression()` to create a
   `progression` condition and then use
   `withRestart(signalCondition(cond), muffleProgression = function(p)
   NULL)` to signal it.


# Version 0.9.0 [2021-09-24]

## Performance

 * The progressor function created by `progressor()` no longer
   "inherit" objects from the calling environment, which would, for
   instance, result in those objects to be exported to parallel
   workers together with the progressor function, which in turn would
   come with large time and memory costs.
   
 * `progressor()` no longer records the call stack for progressions by
   default, because that significantly increases the size of these
   condition objects, e.g. instead of being 5 kB it may be 500 kB.  If
   a large number of progress updates are signaled and collected, as
   done, for instance, by futures, then the memory consumption on the
   collecting end could become very large. The large sizes would also
   have a negative impact on the performance in parallelization with
   futures because of the extra overhead of transferring these extra
   large conditions from the parallel workers back to the main R
   session.  These issues has been there since **progressr** 0.7.0
   (December 2020).  To revert to the previous behavior, use
   `progressor(..., trace = TRUE)`.

## New Features

 * `progressor()` gained argument `trace` to control whether or not
   the call stack should be recorded in each `progression` condition.
   
 * Now `print()` for `progressor` functions and `progression`
   conditions report also on the size of the object, i.e. the number
   of bytes it requires when serialized, for instance, to and from a
   parallel worker.

## Bug Fixes

 * Registered progression handlers would report on progress also when
   in a _forked_ parallel child processes, e.g. when using
   `parallel::mclapply()`.  This would give a false impression that
   **progressr** updates would work when using `parallel::mclapply()`,
   which is not true. Note however, that it does indeed work when
   using the future 'multicore' backend, which uses forks.


# Version 0.8.0 [2021-06-09]

## Significant Changes

 * Creating a new `progressor()` will now automatically finish an
   existing progressor, if one was previously created in the same
   environment.  The previous behavior was to give an error (see below
   bug fix).

 * `R_PROGRESSR_*` environment variables are now only read when the
   **progressr** package is loaded, where they set the corresponding
   `progressr.*` option.  Previously, some of these environment
   variables were queried by different functions as a fallback to when
   an option was not set.  By only parsing them when the package is
   loaded, it decrease the overhead in functions, and it clarifies
   that options can be changed at runtime whereas environment
   variables should only be set at startup.

 * When using `withProgressShiny()`, progression messages now updates
   the `detail` component of the Shiny progress panel.  Previously, it
   updated the `message` component. This can be configured via new
   `inputs` argument.
 
## New Features

 * `withProgressShiny()` gained argument `inputs`, which can be used
   to control whether or not Shiny progress components `message` and
   `detail` should be updated based on the progression message, e.g.
   `inputs = list(message = "sticky_message", detail = "message")`
   will cause progression messages to update the `detail` component
   and sticky ones to update both.
   
 * Now supporting zero-length progressors, e.g. `p <- progressor(along
   = x)` where `length(x) == 0`.
   
 * Add `handlers("rstudio")` to report on progress in the RStudio
   Console via the RStudio Job interface.

## Beta Features

 * As an alternative to specifying the relative amount of progress,
   say, `p(amount = 2)`, it is now possible to also specify the
   absolute amount of progress made this far, e.g. `p(step = 42)`.
   Argument `amount` has not effect when argument `step` is specified.
   WARNING: Argument `step` should only be used when in full control
   of the order when this `progression` condition is signaled.  For
   example, it must not be signaled as one of many parallel progress
   updates signaled concurrently, because we cannot guarantee the
   order these progressions arrive.

## Bug Fixes

 * In **progressr** 0.7.0, any attempt to use more than one progressor
   inside a function or a `local()` call would result in: "Error in
   assign("...progressor", value = fcn, envir = envir) : cannot change
   value of locked binding for ...progressor."

## Deprecated and Defunct

 * Function `progress()` is deprecated in order to re-use it for other
   purpose.  It is unlikely that anyone really used this function, but
   if you did, then use `cond <- progression()` to create a
   `progression` condition and then use
   `withRestart(signalCondition(cond), muffleProgression = function(p)
   NULL)` to signal it.
   

# Version 0.7.0 [2020-12-11]

## Significant Changes

 * The user can now use `handlers(global = TRUE)` to enable progress
   reports everywhere without having to use `with_progress()`.  This
   only works in R (>= 4.0.0) because it requires global calling
   handlers.

 * `with_progress()` now reports on progress from multiple consecutive
   progressors, e.g. `with_progress({ a <- slow_sum(1:3); b <-
   slow_sum(1:3) })`.

 * A progressor must not be created in the global environment unless
   wrapped in `with_progress()` or `without_progress()` call.
   Ideally, a progressor is created within a function or a `local()`
   environment.

 * Package now requires R (>= 3.5.0) in order to protect against
   interrupts.

## New Features

 * `progressor()` gained argument `enable` to control whether or not
   the progressor signals `progression` conditions.  It defaults to
   option `progressr.enable` so that progress updates can be disabled
   globally.  The `enable` argument makes it easy for package
   developers who already provide a `progress = TRUE/FALSE` argument
   in their functions to migrate to the **progressr** package without
   having to change their existing API, e.g. the setup becomes `p <-
   progressor(along = x, enabled = progress)`.  The `p()` function
   created by `p <- progressor(..., enable = FALSE)` is an empty
   function with near-zero overhead.

 * Now `with_progress()` and `without_progress()` returns the value of
   the evaluated expression.
   
 * The progression message can now be created dynamically based on the
   information in the `progression` condition.  Specifically, if
   `message` is a function, then that function will called with the
   `progression` condition as the first argument. This function should
   return a character string.  Importantly, it is only when the
   progression handler receives the progression update and calls
   `conditionMessage(p)` on it that this function is called.
   
 * `progressor()` gained argument `message` to set the default message
   of all progression updates, unless otherwise specified.

 * `progressor()` gained argument `on_exit = TRUE`.

 * Now the `progress` handler shows also a spinner by default.
 
 * Add the 'pbcol' handler, which renders the progress as a colored
   progress bar in the terminal with any messages written in the
   front.

 * Progression handlers now return invisibly whether or not they are
   finished.
 
## Bug Fixes

 * Zero-amount progress updates never reached the progress handlers.
 
 * Argument `enable` for `with_progress()` had no effect.
 

# Version 0.6.0 [2020-05-18]

## Significant Changes

 * Now `with_progress()` makes sure that any output produced while
   reporting on progress will not interfere with the progress output
   and vice versa, which otherwise is a common problem with progress
   frameworks that output to the terminal, e.g. progress-bar output is
   interweaved with printed objects.  In contrast, when using
   **progressr** we can use `message()` and `print()` as usual
   regardless of progress being reported or not.

## New Features

 * Signaling `progress(msg, class = "sticky")` will cause the message
   to be sticky, e.g. for progress bars outputting to the terminal,
   the message will be "pushed" above the progress bar.

 * `with_progress()` gained argument `delay_terminal` whose default
   will be automatically inferred from inspecting the currently set
   handlers and whether they output to the terminal or not.

 * Arguments `delay_stdout` and `delay_conditions` for
   `with_progress()` is now agile to the effective value of the
   `delay_terminal` argument.

 * Now handler_nnn() functions pass additional arguments in `...` to
   the underlying progress-handler backend,
   e.g. `handler_progress(width = 40L)` will set up
   `progress::progress_bar$new(width = 40L)`.
 
 * Add environment variables `R_PROGRESSR_CLEAR`,
   `R_PROGRESSR_ENABLE`, `R_PROGRESSR_ENABLE_AFTER`,
   `R_PROGRESSR_TIMES`, and `R_PROGRESSR_INTERVAL` for controlling the
   default value of the corresponding `progressr.*` options.
 
## Bug Fixes

 * Limiting the frequency of progress reporting via handler arguments
   `times`, `interval` or `intrusiveness` did not work and was
   effectively ignored.
   
 * The `progress` handler, which uses `progress::progress_bar()`, did
   not support colorization of the `format` string when done by the
   `crayon` package.

 * `handlers()` did not return invisible (as documented).

 * Argument `target` was ignored for all handler functions.

 * Argument `interval` was ignored for `handler_debug()`.

 * The class of `handler_<nnn>()` functions where all
   `reset_progression_handler` rather than
   `<nnn>_progression_handler`.  The same bug caused the reported
   `name` field to be `"reset"` rather than `"<nnn>"`.
 

# Version 0.5.0 [2020-04-16]

## New Features

 * Add 'void' progression handler.

## Bug Fixes

 * Only the last of multiple progression handlers registered was used.


# Version 0.4.0 [2020-01-22]

## Significant Changes

 * All progression handler function have been renamed from
   `<name>_handler()` to `handler_<name>()` to make it easier to use
   autocompletion on them.


# Version 0.3.0 [2020-01-20]

## New Features

 * `progressor()` gained arguments `offset` and `scale`, and
   `transform`.

 * `handlers()` gained argument `append` to make it easier to append
   handlers.
 
## Bug Fixes

 * A `progression` condition with `amount = 0` would not update the
   message.

 
# Version 0.2.1 [2020-01-04]

## Bug Fixes

 * `winprogressbar_handler()` would produce error "invalid 'Label'
   argument".

 * `handlers()` did not return a list if the 'default' handler was
   returned.
 

# Version 0.2.0 [2020-01-04]

## Significant Changes

 * Renamed `withProgress2()` to `withProgressShiny()`.

## New Features

 * `handlers()` gained argument `default` specifying a progression
   handler to be returned if none is set.


# Version 0.1.5 [2019-10-26]

## New Features

 * Add `withProgress2()`, which is a plug-in backward compatibility
   replacement for `shiny::withProgress()` wrapped in
   `progressr::with_progress()` where the the "shiny" progression
   handler is by default added to the list of progression handlers
   used.

 * Add `demo("mandelbrot", package = "progressr")`.

## Bug Fixes

 * Package could set `.Random.seed` to NULL, instead of removing it,
   which in turn would produce a warning on "'.Random.seed' is not an
   integer vector but of type 'NULL', so ignored" when the next random
   number generated.


# Version 0.1.4 [2019-07-02]

## New Features

 * Add support for `progressor(along = ...)`.
 

# Version 0.1.3 [2019-07-01]

## New Features

 * Now it is possible to send "I'm still here" progression updates by
   setting the progress step to zero, e.g. `progress(amount = 0)`.
   This type of information can for instance be used to updated a
   progress bar spinner.

 * Add utility function `handlers()` for controlling option
   `progressr.handlers`.
 
 * Progression handlers' internal state now has a sticky `message`
   field, which hold the most recent, non-empty progression `message`
   received.


# Version 0.1.2 [2019-06-14]

## New Features

 * `with_progress()` gained arguments `enable` and `interval` as an
   alternative to setting corresponding options `progressr.*`.

 * Now option `progressr.interval` defaults to 0.0 (was 0.5 seconds).

 * Added print() for `progression_handler` objects.
 
## Bug Fixes

 * `with_progress(..., delay_conditions = "condition")`, introduced in
   **progressr** 0.1.0, would also capture conditions produced by
   progression handlers, e.g. `progress::progress_bar()` output would
   not be displayed until the very end.


# Version 0.1.1 [2019-06-08]

## New Features

 * `with_progress()` now captures standard output and conditions and
   relay them at then end.  This is done in order to avoid
   interweaving such output with the output produced by the
   progression handlers.  This behavior can be controlled by arguments
   `delay_stdout` and `delay_condition`.
 

# Version 0.1.0 [2019-06-07]

## New Features

 * Now a `progression` condition is identified from the R session
   UUID, the progressor UUID, the incremental progression index, and
   the progression timestamp.
   
## Bug Fixes

 * A progressor object that was exported to the same external R
   process multiple times would produce `progression` conditions that
   was non-distinguishable from those previously exported. Adding a
   timestamp to the `progression` condition makes them
   distinguishable.


# Version 0.0.6 [2019-06-03]

## New Features

 * Add `print()` for `progression` conditions and `progressor`
   functions.

 * Now the progressors record more details on the session information.
   This information is passed along with all `progression` conditions
   as part of the internal owner information.
 

# Version 0.0.5 [2019-05-20]

## New Features

 * Add filesize_handler progression handler.
 
 * Add support for `times = 1L` for progression handlers which when
   used will cause the progression to only be presented upon
   completion (= last step).

 * The `shutdown` control_progression signaled by `with_progress()` on
   exit now contains the `status` of the evaluation.  If the
   evaluation was successful, then `status = "ok"`, otherwise
   `"incomplete"`.  Examples of incomplete evaluations are errors and
   interrupts.
   

# Version 0.0.4 [2019-05-18]

## New Features

 * Add `utils::winProgressBar()` progression handler for MS Windows.
 
 * Add support for silent sounds for `beepr::beep()`.

 * Add option `progressr.enable`, which defaults to `interactive()`.

## Software Quality

 * TESTS: Increased package test coverage of progression handlers by
   running all code except the last step that calls the backend, which
   may not be installed or supported on the current platform,
   e.g. **tcltk**, **beepr**, notifier.

## Bug Fixes

 * Precreated progression handlers could only be used once.

 * `with_progress(..., cleanup = TRUE)` requires a `withRestart()`
   such that also "shutdown" progressions can be muffled.
 

# Version 0.0.3 [2019-05-17]

## New Features

 * Add argument `enable_after` for progression handlers.
 
 * Now `with_progress(..., cleanup = TRUE)` will signal a generic
   "shutdown" progression at the end that will trigger all progression
   handlers to finish up regardless of all steps have been take or
   not.

 * Now progressions originating from an unknown source are ignored.
 
 * The default output format of the `progress::progress_bar()`
   progression handler is now `":percent :bar :message"`.

 * The `tcltk::tkProgressBar()` progression handler now displays the
   progression message.

 * Now the `progression` condition itself is passed to the progression
   reporter functions.
   
 * Add 'debug_handler' for prototyping and debugging purposes.

 * Add 'newline_handler' to add newlines between output of multiple
   handlers.

 * Argument `intrusiveness` may now be zero. Previously it had to be a
   strictly positive value.

 * Add `without_progress()` - which causes all `progression`
   conditions to be muffled and ignored.
   
## Bug Fixes

 * Progressor functions could produce `progression` conditions that
   had the same identifiers and therefore would be considered
   duplicates such that progression handlers would ignore them.

 * It was an error if a progression took a step big enough to skip
   more than the next milestone.

 * Progression handlers now keep the internal `step` field within
   [0, max_steps] in case of a too big progression step is taken.

 * Progression updates received after progression handler is finished
   would keep increasing the internal step field.
 

# Version 0.0.2 [2019-05-15]

## Significant Changes

 * Renamed restart `consume_progression` to `muffleProgression` to
   align with restarts `muffleMessage` and `muffleWarning` in base R.

## New Features

 * Add a plyr-compatible "progress bar" named `progress_progressr()`.

 * Add option `progressr.clear`.

 * Visual progression handler will now always render the complete
   update state when `clear` is FALSE.

 * Now progression handlers ignore a re-signaled `progression`
   condition if it has already been processed previously.
 
 * Now each `progression` condition holds unique identifiers for the R
   session and for the progressor that produced the condition.  It
   also contains an unique index per progressor that is incremented
   whenever a new `progression` condition is created.


# Version 0.0.1 [2019-05-08]

## Significant Changes

 * First decent prototype of this package and the idea behind it.
 
 * Make `auto_done = TRUE` the default.
 

# Version 0.0.0-9004 [2019-05-08]

## New Features

 * Add argument `auto_done` to automatically have progress updates
   also signal "done" as soon as the last step has been reached.

 * Made `amount` the first argument of progressors to avoid having to
   specify it by name if progressing with an amount than the default
   `amount = 1.0`.

 * Add argument `clear` to control whether progress reporter should
   clear its output upon completion.  The default is to do this, where
   supported.

 * Add progress update handler based on `pbmcapply::progressBar()`.

 * Each achieved step is now timestamped.

 * Add option `progressr.debug`.
 

# Version 0.0.0-9003 [2019-05-06]

## New Features

 * Add `intrusiveness` parameter that specifies how
   intrusive/disruptive a certain progress reporter is.  For instance,
   an auditory reporter is relatively more disruptive than a visual
   progress bar part of the status bar.

 * Simplified the API for creating new types of progress reporters.
 

# Version 0.0.0-9002 [2019-04-25]

## New Features

 * Add `progressor()`.

 * Add `progress_aggregator()`.


# Version 0.0.0-9001 [2019-04-24]

## New Features

 * Add progress update handlers based on `utils::txtProgressBar()`,
   `tcltk::tkProgressBar()`, `cat("\a")`, `progress::progress_bar()`,
   `beepr::beep()`, and `notifier::notify()`.

 * Add `with_progress()`.

 * Add options `progressr.handlers` for settings default progress handlers.

 * Add `progressr.times` for controlling the number of times progress
   updates are rendered.

 * Add `progressr.interval` for controlling the minimum number of seconds
   that needs to elapse before reporting on the next update.
 

# Version 0.0.0-9000 [2019-04-11]

## New Features

 * Add `progress()` to create and signal `progression` condition.

 * Add `progression()` to create `progression` condition.
