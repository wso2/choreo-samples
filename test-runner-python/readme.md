Use template (Test Runner Python) to write and execute automated tests against applications hosted in Choreo or any 3rd party services.

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results and logs can be viewed from the Choreo console.

## Prerequisites

- Python 3.x installed in your local machine.

## Run the template

Run the python test suite using `python -m pytest main.py` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
python -m pytest main.py
====================================================== test session starts ======================================================
platform darwin -- Python 3.10.13, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/lahirudesilva/Dev/Projects/choreo-samples/test-runner-python
collected 1 item

main.py .                                                                                                                 [100%]

======================================================= 1 passed in 0.63s =======================================================
```
