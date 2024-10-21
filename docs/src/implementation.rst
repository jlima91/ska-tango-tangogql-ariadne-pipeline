TangoGQL Ariadne Implementation
===============================

The current implementation of TangoGQL, using **Ariadne**, integrates with **Starlette** for serving GraphQL queries and WebSocket subscriptions, providing modern and efficient queryable access to a Tango Control System. This documentation outlines the server setup, key routes, middleware configuration, and resolver functionality.

Server Setup
============

The production server is set up using **Ariadne's ASGI GraphQL handler** integrated into a Starlette application. The handler manages both HTTP routes and WebSocket connections to serve GraphQL queries and subscriptions.

The key components include:

- **GraphQL Handler**: This is responsible for processing incoming GraphQL queries and mutations.

- **Context**: A custom `get_context_value` function is used to inject request-specific data into the resolver context.

- **Routes**: The server supports HTTP requests via `/db` and WebSocket subscriptions via `/socket`.

- **Middleware**: CORS middleware is added to handle cross-origin requests, allowing interactions from any origin.

Middleware
==========

The **CORS (Cross-Origin Resource Sharing)** middleware is configured to:

- Allow requests from any origin (`allow_origins=["*"]`).

- Allow credentials, methods, and headers to ensure full access from external clients.

GraphQL Resolvers
=================

The implementation includes several key resolver functions that handle mutations for interacting with Tango devices. These are built using Ariadne’s `ObjectType` and decorated with authorization checks.

- **Mutations**: The core mutations allow modification of Tango device properties and attributes, as well as execution of device commands.
  
  1. **putDeviceProperty**: Allows the setting of device properties using the async TangoDB.

  2. **deleteDeviceProperty**: Deletes properties from a Tango device.

  3. **setAttributeValue**: Updates a Tango device's attribute with a new value and returns the previous value for reference.

  4. **executeCommand**: Executes a Tango device command, optionally with arguments.

Each mutation is wrapped with an authorization check using the `@check_auth` decorator to verify if the client has the required credentials and group memberships before proceeding with the operation.

Error Handling
==============

Each resolver is designed to handle common errors, such as:

- **tango.DevFailed** exceptions when device operations fail.

- **TypeError** exceptions when the input argument types are invalid.

Error messages are logged for debugging purposes, and a standard response structure is returned to the client indicating the success or failure of the operation.

Authentication and Authorization
================================

The authentication mechanism relies on **JWT (JSON Web Tokens)** stored in client cookies. These tokens are verified on each request to ensure that the user is logged in and belongs to the required groups.

- **Auth Claims**: The authentication information is extracted from the `taranta_jwt` cookie and verified using the application’s secret key.

- **Authorization Checks**: The `check_auth` decorator enforces that only authorized users (those belonging to the necessary groups) can perform certain operations. This can be disabled globally by setting the `NO_AUTH` environment variable, allowing all requests to bypass authentication.

Custom GraphQL errors are defined for handling authentication and authorization issues:

- **AuthenticationError**: Raised when the user is not logged in.

- **AuthorizationError**: Raised when the user does not belong to the required groups to execute a specific operation.

Summary of Key Functionalities:
===============================

1. **GraphQL Queries**: Serve queries and mutations through HTTP and WebSocket routes using Ariadne’s GraphQL handler.

2. **Mutations**: Support for key operations such as setting device properties, writing attributes, and executing commands on Tango devices.

3. **Authorization**: JWT-based authentication with group membership enforcement to control access to resolvers.

4. **Error Handling**: Robust logging and exception management for Tango device operations and input validation.
