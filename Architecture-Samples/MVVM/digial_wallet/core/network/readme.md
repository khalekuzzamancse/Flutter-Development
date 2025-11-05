
### Info

- Do the networking operation such as `GET,PUT,POST,DELETE`

- Takes return only the `JSON` or `throw` meaningful `CustomException`

- It has dependencies on `custom-exception` `package`

- It `hide` the underlying` library` and 
`implementation` to the `client package` so that it internal dependencies
or `implementations` can be changed without affecting the client packages

- The client packages should only depends on the abstraction and must create the instances via the `factory` method
that is defined in this package

- Currently using built-runner and annotations for code generation such as json serialization, once the `dart macro`
has stable version we will move to that,but the client packages should worry about the underlying library

- So this act as `Facade` for the client package

## API it exposes
- JSON parser
    - Parse a given `JSON as T` or `throw` `custom exception`
    - Check a given `JSON` can be parsed as `T` or 
- method for `HTTP request`

### How to use it ?
- Check the `test` directory to find how should be it used
- Most of the method for defined in `ApiClient` so you can directly use it instead of separately use the parser, under the hood the `ApiClient` use the parser to pares
