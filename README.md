# sqlfluff-demo

## Resources
- [venv](https://docs.python.org/3/library/venv.html)
- pip
- [sqlfluff](https://docs.sqlfluff.com/en/stable/gettingstarted.html)
- VS Code

## 1. Clone this repo (optional)

If you want a reference point or want to skip some setup steps, you can clone this repository. There's a `requirements.txt` if you want to use it for a virtual environment, but you don't need one.

```
git clone https://github.com/tjack-norris/sqlfluff-demo.git
```

## 2. Create new virtual environment (optional)

Make a new venv (or use a package system of choice, eg. Conda) the root folder of the cloned repo, or wherever you want to test out this linter:

```
python -m venv <venv>

source <venv>/bin/activate
```

## 3. Install sqlfluff

```
pip install sqlfluff
```

## 4. Run sqlfluff

### Lint a file
```
sqlfluff lint models/model_.sql
```
Oops! You need to specify a SQL dialect in the command (unless you have a stored sqlfluff config file, more on this later).

We will use the `bigquery` dialect in this repository.

```
sqlfluff lint models/model_.sql --d bigquery
```
Now, sqlfluff responds with all the cases where the file violates a [Rule](https://docs.sqlfluff.com/en/stable/rules.html) (they have default definitions):
```
== [models/model_.sql] FAIL
L:   1 | P:   1 | LT09 | Select targets should be on a new line unless there is
                       | only one select target.
                       | [layout.select_targets]
L:   1 | P:   1 | ST06 | Select wildcards then simple targets before calculations
                       | and aggregates. [structure.column_order]
L:   1 | P:   7 | LT02 | Expected line break and indent of 4 spaces before
                       | 'column1'. [layout.indent]
L:   1 | P:  16 | LT01 | Unnecessary trailing whitespace.
                       | [layout.spacing]
L:   2 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   2 | P:  10 | CP01 | Keywords must be consistently upper case.
                       | [capitalisation.keywords]
L:   3 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   3 | P:   1 | LT04 | Found leading comma ','. Expected only trailing near
                       | line breaks. [layout.commas]
L:   3 | P:   2 | LT01 | Expected single whitespace between comma ',' and naked
                       | identifier. [layout.spacing]
L:   4 | P:   1 | LT02 | Line should not be indented.
                       | [layout.indent]
L:   5 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   6 | P:  22 | LT12 | Files must end with a single trailing newline.
                       | [layout.end_of_file]
```

That's a lot to fix, but don't worry.

### Fix all Rule violations

You can now fix these errors with the `fix` command, you will be prompted to review the fixes and approve or decline them.
```
sqlfluff fix models/model_.sql -d bigquery -x fixed
```
Using `-x TEXT` applies `TEXT` as a suffix to the linted and fixed file.

To skip prompts before fixing, use `-f`.

### Ignore a Rule

We can skip over specific Rules if needed. If we don't want to care about trailing whitespace violabtions we can ignore Rule [LT01](https://docs.sqlfluff.com/en/stable/rules.html#rule-LT01):
```
sqlfluff fix models/model_.sql -d bigquery -x fixed -e LT01
```
You will see that our previous trailing whitespace violation is nowhere to be seen:
```
==== finding fixable violations ====
== [models/model_.sql] FAIL
L:   1 | P:   1 | LT09 | Select targets should be on a new line unless there is
                       | only one select target.
                       | [layout.select_targets]
L:   1 | P:   1 | ST06 | Select wildcards then simple targets before calculations
                       | and aggregates. [structure.column_order]
L:   1 | P:   7 | LT02 | Expected line break and indent of 4 spaces before
                       | 'column1'. [layout.indent]
L:   2 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   2 | P:  10 | CP01 | Keywords must be consistently upper case.
                       | [capitalisation.keywords]
L:   3 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   3 | P:   1 | LT04 | Found leading comma ','. Expected only trailing near
                       | line breaks. [layout.commas]
L:   4 | P:   1 | LT02 | Line should not be indented.
                       | [layout.indent]
L:   5 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   6 | P:  22 | LT12 | Files must end with a single trailing newline.
                       | [layout.end_of_file]
==== fixing violations ====
10 fixable linting violations found
Are you sure you wish to attempt to fix these? [Y/n]
```

Note that running `sqfluff fix` on the same file with the same argument passed with `-x` overwrites any file that already matches the target file with the suffix added.

## 5. Run sqlfluff with custom configuration

The rules used by sqlfluff when it lints are set by default. We can override the default rules with our own configurations.

```
touch .sqlfluff

code .sqlfluff
```

When you have created you configuration file, you can begin to add your own configuration to it, for example:

```
[sqlfluff]

[sqlfluff:layout:type:comma]
line_position = leading
```

The sqfluff lint and fix commands will now regard trailing commas as a violation of Rule LT04 (which defaults to `trailing`):
```
== [models/model_.sql] FAIL
L:   1 | P:   1 | LT09 | Select targets should be on a new line unless there is
                       | only one select target.
                       | [layout.select_targets]
L:   1 | P:   1 | ST06 | Select wildcards then simple targets before calculations
                       | and aggregates. [structure.column_order]
L:   1 | P:   7 | LT02 | Expected line break and indent of 4 spaces before
                       | 'column1'. [layout.indent]
L:   1 | P:  15 | LT04 | Found trailing comma ','. Expected only leading near
                       | line breaks. [layout.commas]
L:   1 | P:  16 | LT01 | Unnecessary trailing whitespace.
                       | [layout.spacing]
L:   2 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   2 | P:  10 | CP01 | Keywords must be consistently upper case.
                       | [capitalisation.keywords]
L:   3 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   3 | P:   2 | LT01 | Expected single whitespace between comma ',' and naked
                       | identifier. [layout.spacing]
L:   4 | P:   1 | LT02 | Line should not be indented.
                       | [layout.indent]
L:   5 | P:   1 | LT02 | Expected indent of 4 spaces.
                       | [layout.indent]
L:   6 | P:  22 | LT12 | Files must end with a single trailing newline.
                       | [layout.end_of_file]
```

Quoted from the sqlfluff documentation:
>When setting up a new project with SQLFluff, we recommend keeping your configuration file fairly minimal. The config file should act as a form of documentation for your team i.e. a record of what decisions you’ve made which govern how your format your SQL. By having a more concise config file, and only defining config settings where they differ from the defaults - you are more clearly stating to your team what choices you’ve made.

## 6. Linting with sqlfuff in IDE

1. Install the VS Code extension named sqlfluff (Extension ID: dorzey.vscode-sqlfluff).
2. Open the Extension Settings for your VS Code User or current Workspace.
3. Run `which sqfluff` in your shell command prompt to get the path to the sqlfluff executable.
4. Paste the sqlfluff executable path as the value of the `sqlfluff.executablePath` key in your settings file.
5. You can also change more settings to your liking.

Your workspace settings file may now look something like this:
```
{
	"folders": [
		{
			"path": "."
		}
	],
	"settings": {
		"sqlfluff.codeActions.noqa": [],
		"sqlfluff.executablePath": "/Users/simon/Code/sqlfluff-demo/.venv/bin/sqlfluff",
		"sqlfluff.linter.run": "onType",
		"sqlfluff.config": ".sqlfluff",
		"sqlfluff.dialect": "bigquery"
	}
}
```

You have specified where you additional configuration can be found, when the linter should run in your IDE (`onType`) and what dialect it should lint for.

To test this, open or create a SQL file in VS Code in the Workspace where you have set up sqlfluff. Write in an obvious error or rule violation in it and save it. VS Code should now be highlighting all errors it finds.
