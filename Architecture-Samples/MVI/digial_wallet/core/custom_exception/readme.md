### Motivation
Form previously working in lots of  with multi module projects with `Clean Architecture` find that each module
need a custom exception where 95% exception are common, if we define the exception within each module then 
we are duplicating as a result if we need to change the modify some exception and add something new 
in hurry then it cause problems because of we may forget to update some modules and etc,
so I found that maintaining single source of truth  is  make sense , It not also save from duplication but also
save lots of time and feature break when we hurry so that we need to deliver the project quickly.

More ever because managing single source of truth so it can be used to any project so the if we are developing
a new project we no need to write it from scratch

### More info


- Define the `custom exception` that so it can represent as framework independent

- In case of `Clean Architecture` every `domain` layer(module/package) must use as dependency

- It cover 90% of the `Exceptions` however a `module` need to it own exception then they can define their own exception by `inheriting` `CustomException` class

- `CustomException` class has 3 fields:
    - message: that is short and end user friendly ,this can be shown to directly to the `end user`
        such in in case of `Flutter` it can be shown in a `Snackbar`

    - debugMessage: that is details message with cause and the source, it will be used for the developer to 
    debug and find the bug , these message never should expose to the `end user`

    - errorCode: This a 3-4 length short code, this can be shown to `end user` so that `end user` can tell to developer what that `errorCode` was then according to the `developer` can easily find the `Exception` name and 
    see the `debug` message and fix it, this is helpful because sometimes some `Unknown Exception` occurs that 
    `Exception` name or description exposing to the `end user` is meaningless because the `end user` will not understand these `message`, in that case it is make sense to show the message=`ErrorCode:something is went wrong`  to the `end user` however as developer we have to debug this kind of `exception`,so  need to take feedback the `end user` that what the `error` was ,then `end user` tell the `ErrorCode` and for the developer
    it is easy to reason about the error
