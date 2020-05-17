port module Main exposing (..)

import List.Extra
import Maybe.Extra
import Platform


type alias Model =
    {}


type Msg
    = Return (List String)


init : List String -> ( Model, Cmd Msg )
init strs =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Return args ->
            ( model
            , returnResult <| grep args
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    getArgs Return


main : Platform.Program (List String) Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


port returnResult : String -> Cmd msg


port getArgs : (List String -> msg) -> Sub msg


grep : List String -> String
grep args =
    let
        query =
            Maybe.withDefault "" (List.head args)

        lowerQuery =
            String.toLower query

        linesList =
            String.lines <| Maybe.withDefault "" (List.Extra.last args)

        lowerLinesList =
            List.map String.toLower linesList

        idxList =
            List.Extra.findIndices (String.contains lowerQuery) lowerLinesList
    in
    String.join "\n" <|
        Maybe.Extra.values <|
            List.map
                (\n ->
                    List.Extra.getAt (Maybe.withDefault 0 (List.Extra.getAt n idxList)) <|
                        linesList
                )
            <|
                List.range 0 (List.length idxList - 1)
