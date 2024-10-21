Joint Process for Contribution between Max IV and SKA
======================================================

This relates to how the teams at Max IV and SKA have agreed to
collaberate on supporting and ehancing the taranta suite of tools.

What is this collaboration about?
---------------------------------

This is a collaboration between software teams in MaxIV and the Square
Kilometer Array (SKA) to jointly work on developing the taranta suite.
This is a number of closely related products that can be used to provide
a web-based interface to a Tango Control System.

What are the Products we are collaborating on?
----------------------------------------------

.. list-table:: 
   :widths: 2 1 3
   :header-rows: 1

   * - Purpose
     - Repository
     - Description
   * - A tool for creating Dashboards for 
       interacting with the devices 
       within a Tango Control System
     - https://gitlab.com/tango-controls/web/taranta.git
     - The tool for developing these dashboards is taranta itself.  

   * - Queryable access to a Tango Control System that can be used by the 
       dashboard creation tool
     - https://gitlab.com/tango-controls/web/tangogql.git
     - Currently, this is a TangoGQL. A GraphQL web server that integrates with the 
       TangoDB services and cancommunicate directly with tango devices.

   * - Storing and Sharing the configuration of developed dashboards
       between users
     - https://gitlab.com/tango-controls/web/taranta-dashboard.git     
     - A MongoDB based dashboard repository for storing taranta dashboard   
       layouts

   * - Authorization and Authentication for the tools 
     - https://gitlab.com/tango-controls/web/taranta-auth.git 
     - A simple authentication and authorization service for the taranta and 
       TangoGQL tools that can be hooked into a corporate       
       authentication solution 

   * - Supporting further development
     - https://gitlab.com/tango-controls/web/taranta-suite.git
     - A set of developer scripts and tools used for setting up and developing 
       these related products. 

This division is not defined in any specification, but rather has
emerged from the needs of the application. In the future, services might
be added, merged or made obsolete.

Planning Process
----------------

Priorities are agreed on a regular basis between the MaxIV Product and
Feature Owners who meet regularly with their SKA compatriots. Within the
SKA Planning fits within the current 3 monthly cycle for software. The
outcomes of the SKA planning and joint discussions with Max IV are:

-  An agreed set of common priorities between SKA and MaxIV.
-  An updated backlog of taranta suite features recorded as GitLab
   Issues against the relevant project ( general issues being raised
   against `taranta <https://gitlab.com/tango-controls/web/taranta>`__ )
-  A single view of all the GitLab issues across the taranta suite that 
   summarises the current GitLab Issues from each of the contributing 
   projects.
-  A plan for the next 3 months of work covering which features are
   going to be worked on in which 2wk period, with these features having
   an approximate size, acceptance criteria, an allocated feature owner
   and agreement which team is best placed to tackle them.

(It is important that SKA discuss their priorities with MaxIV and vice
versa before tickets are raised)

Once accepted as part of a team’s work for the next period the GitLab
issue should be updated to include a cross-reference to the internally
tracked work item (JIRA for SKA / TAGIA for MaxIV) [1]_

Making Changes
--------------

-  **There is a single master branch that should always be deployable and
   usable.** This is supported by Continuous Integration by both MaxIV and
   SKA
-  **Changes are made via short-lived feature branches that are merged
   back into master.** Branch names should reflect the GitLab ticket being
   worked on
-  **All changes should have an associated GitLab ticket.**
-  **All features are merged via pull requests** - at least initially it
   would make sense to have all changes reviewed by one MaxIV and one
   SKA developer before being merged back into master.
   **HotFix/Emergency Fixes** are reviewed quickly by a second developer
   on the same side and communicated retrospectively
   **Review policy for planned changes** when a change is ready for
   merging with the trunk the party responsible raises a pull request,
   requesting a review with a priority (urgent, high medium, low
   priority). A priority defines generally how urgently the review
   should be actioned. At this early stage of the collaboration, this is
   on a best efforts basis without any specific deadlines. If it is not
   possible for the other party to review the code then the code will be
   merged back to the master after peer review by another developer
   within the collaboration.

Testing
-------

The tests for these projects are not currently comprehensive in terms of
coverage. The ambition is to evolve this over time. We want to ensure
that new code developed is delivered with tests that demonstrate that it
is fit for purpose, and is documented in a way that makes it easy to
maintain.

Testing legacy code
~~~~~~~~~~~~~~~~~~~

-  It is **not necessary to add tests on existing code**.
-  When a **bug in legacy code has been discovered**: open a GitLab
   issue, fix the bug and create tests. In this way, it is possible to
   improve coverage.

Testing of new code or changed functionality:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  **All new or changed code should have tests**
-  **All new or changed code should have documentation**
-  **Trunk should always be clean and deployable** - no breaking code,
   all tests and linting OK. The CI/CD should run cleanly on both sides. 

Coding Standards and Programming Language Conventions 
-----------------------------------------------------
Webjive and related JavaScript based projects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


We are starting from the principle that we want to move towards a
defined coding standard, but without forcing a large amount of cosmetic
change on the existing codebase.

The following tools are integrated into the environments. This list may
be expanded or change as the needs of the project changes.


.. list-table:: 
   :widths: 1 2
   :header-rows: 1

   * - Purpose
     - Tool of Choice
   * - linting of files
     - eslint, @typescript-eslint/parser and @typescript-eslint/eslint-plugin
   * - testing of code
     - jest, ts-jest, enzyme,
   * - formatting of code
     - prettier
   * - code coverage
     - jest
   * - dependency management
     - npm
   * - CI/CD
     - GitLab pipeline (gitlab-ci.yml file)

All existing code should as a minimum conform to the de-facto linting
and formatting rules within the workspace.

These are currently relaxed in a number of areas, but the plan would be
to improve the quality of the code over time enforcing stricter rules
based on best practices defined by Airbnb and Microsoft after
discussion.

Any exceptions to this would be documented on the publicly accessible
SKA developer guidance for javascript.

For personal linting or formatting of code, it is suggested that
developers use the appropriate AirBnB standards rules and plugins for
their preferred editor. Guidance for set-up and configuration to be
supplied as part of the readme on the projects

Use of Typescript
^^^^^^^^^^^^^^^^^

The use of Typescript is acknowledged and supported. It is quite
acceptable for TSX files to contain JSX syntax. Typescript code should
conform to the current typescript rules for static typing (currently 2.7
is enforced 3.3 is suggested for any new code)

For compatibility with the current codebase, the following rules are not
enforced however any new or change code should however be written so
that it would compile and run with these rules in place

-  **strictFunctionTypes** Ensure that all functions can be proved to be
   type safe. [2]_

-  **strictPropertyInitialization** Ensures that all properties are
   initialized for every possible code path. [3]_

-  **noImplicitAny** Currently if the compiler cannot infer the variable
   type based on how it's used it silently defaults the type to any. At
   some point, we want to switch this to true so that if the TypeScript
   compiler cannot infer the type, it still generates the JavaScript
   files, but it also reports an error. This stricter type checking
   catches more unintentional errors at compile time.

Code Structure
^^^^^^^^^^^^^^

The code should, in general, be grouped by features or routes. [4]_  with CSS, JS, and tests
grouped together inside folders. Follow the existing taranta structure
where possible:

* **dashboard** : code relating to the main dashboard display and
* **jive** : code relating to the device lists and RHS panel
* **shared** code used by both

Within this structure, there is a separation between code related to the
state management and the widgets presented on the display.

The folder structure within ‘components’ reflecting a hierarchical view
of the individual components.

TangoGQL and other Python-related projects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Any jointly developed changes should follow the `SKA Python programming
guidelines <http://developer.skatelescope.org/en/latest/development/python-codeguide.html>`__

Definition of Done
------------------

This is based on the `SKA project 'Definition of Done' <http://developer.skatelescope.org/en/latest/agile_practices/definition_of_done.html>`__ 
for software projects

Ticket/Story
~~~~~~~~~~~~

-  Code is supplied with an acceptable license.
-  Code is peer-reviewed (via pull-request process).
-  Code is checked into the repository with reference to GitLab ticket.
-  The code has tests that have adequate (between 75% and 90%) coverage [5]_ 
-  The code compiles cleanly with no warnings.
-  Code adheres to SKA and MaxIV agreed language specific style.
-  Code is deployed to a continuous integration environment for both
   MaxIV and SKA.
-  The code passes regression testing.
-  The code passes ‘smoke’ testing.
-  NFRs are met
-  The story is tested against acceptance criteria.
-  The story is documented.
-  Story ok-ed by Product Owner.

Code documentation
~~~~~~~~~~~~~~~~~~

-  Public API exposed is clearly documented
-  Code is documented inline according to language-specific standards
-  Documentation is peer-reviewed by stakeholder (e.g. Product Owner for
   a feature or technical peer for an enabler) via the pull-request
   mechanism.
-  Documentation is deployed to an externally visible website accessible
   via the SKA developer portal

Feature
~~~~~~~

-  The feature has been demonstrated to relevant stakeholders
-  Feature meets the acceptance criteria
-  The feature is accepted by Feature owner
-  The feature is integrated into both integration environments (MaxIV
   and SKA)
-  Code documentation is integrated as part of the project documentation
   (and developer portal as relevant for SKA)
-  SKA / MaxIV Architectural documentation is updated to reflect the
   actual implementation

Notes
-----

.. [1]
   There are plugins that might help to synchronise. TBC - need to add
   the details of the process.

.. [2]
   see description & ref article in
   https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html

.. [3]
   see
   https://patrickdesjardins.com/blog/typescript-strictpropertyinitialization-should-be-turned-on

.. [4]
   For a discussion of the benefits of grouping by structure see
   https://reactjs.org/docs/faq-structure.html

.. [5]
   Pragmatism is assumed. We will focus testing on the core components where failure 
   would impact multiple users. For example, users can create and deploy 
   their own custom widgets. A failing widget only impacts the users of that widget.
   Here good-enough testing to cover the situations the
   widget has been developed for may well be more lightweight than 
   the coverage percentages would suggest.