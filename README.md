## FOS - Timing Actions

![](https://img.shields.io/badge/Plug--in_Type-Dynamic_Action-orange.svg) ![](https://img.shields.io/badge/APEX-19.2-success.svg) ![](https://img.shields.io/badge/APEX-20.1-success.svg)

<h3>Timing Actions Overview</h3>
<p>A set of actions which handle the timing of remaining actions within a Dynamic Action such as debounce, delay or throttle, as well an action to set up a timer. <strong>Note:</strong> you must enable/check/toggle the dynamic action "Wait for result" option for this plugin to work correctly.</p>
<h3>Delay Action</h3>
<p>Delays the execution of proceeding actions (i.e. higher sequenced) within your dynamic action based on the number of milliseconds provided. </p>
<h3>Debounce Action</h3>
<p>Debounces the execution of the of proceeding actions (i.e. higher sequenced) within a dynamic action. This means that you can ensure that when a dynamic action fires in quick succession it will not run the proceeding actions until X many milliseconds (which you define) from the last call has elapsed. You have the option of immediately executing the first call.</p>
<p><strong>Note:</strong> there are times where throttling makes better sense than debouncing, so please also consider using the throttle action. You can read more about debouncing and throttling <a href="https://stackoverflow.com/questions/25991367/difference-between-throttling-and-debouncing-a-function">here</a></p>
<h3>Throttle Action</h3>
<p>Throttles the execution of the proceeding actions (i.e. higher sequenced) within your dynamic action. For example: if you set this delay to 5000 milliseconds on the click event of a button that refreshes a grid, if you click the button repeatedly in quick succession the maximum you could refresh the grid is once every five seconds.</p>
<p><strong>Note:</strong> there are times where debouncing makes better sense than throttling, so please also consider using the debounce action instead. You can read more about throttling and debouncing <a href="https://stackoverflow.com/questions/25991367/difference-between-throttling-and-debouncing-a-function">here</a></p>
<h3>Timer Action</h3>
<p>The timer action allows you to periodically fire other dynamic actions listening to the <i>Timer Tick</i> or <i>Timer Complete</i> events.</p>
<ul>
<li>The <i>Timer Tick</i> fires upon every repetition after the timeout interval has elapsed.</li>
<li>The <i>Timer Complete</i> fires only once, after the last repetition. In case of an infinite timer i.e. "no limit on repetitions" then the event <i>Timer Complete</i> never fires!</li>
</ul>

## License

MIT

