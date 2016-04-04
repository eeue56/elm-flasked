# elm-flasked

An example usage of driving MVU server code from an Elm client.


One of the things I liked best about server-side Elm was being able to define my API with a union type and know it would just work, because you have the type system flowing throughout your entire application. Without server-side Elm, that's not possible.. but that isn't to say that you can't leverage Elm to take care of a lot that for you.

If you have a model, update, value framework on the server, then it's pretty easy make your web client act as a driver through Elm, simplifying your server-side APIs by reducing each one to a stateless function.

So, let's say we define our APIs like this:

on the client:
```elm
type alias ExampleAdder =
    { add : Int
    }

type ServerCommand
    = ConsoleLog
    | Add Int
    | Sub Int
    | RecordAdd ExampleAdder
```

on the server:

```python
actions = {
    "ConsoleLog": logger,
    "Add": add,
    "Sub": sub,
    "RecordAdd": record_add
}
```

then suddenly, we can talk to our server-side code as though it's server-side Elm, which means now for ​_any API interaction_​, all we need to do is this small little request:

```           
Http.post "/api"
  |> Http.withHeader "Content-Type" "application/json"
  |> Http.withJsonBody (asIs command)
  |> Http.send (Http.jsonReader decodeModel) Http.stringReader
  |> Task.toMaybe
  |> Task.map (\x ->
      case x of
          Just model ->
              UpdateModel model.data
          Nothing ->
              Noop
      )
```

and on the server, then you just define:

```python
@app.route('/api', methods=['POST'])
def api():
    blob = request.get_json()
    app.model = update(blob, app.model)

    return jsonify({
        'model': app.model
    })
```

where `update` takes the blob, figures out the action, then passes the model and returns the new, updated model. Here, our view can be considered to be the json blob returned by the server. Our update is just a stateless update function. Our model is just a model. MVU on the client, MVU on the server
