open Minttea

let dark_gray = Spices.color "241"

let keyword fmt =
  Spices.(default |> faint true |> fg dark_gray |> bold true |> build) fmt

let red fmt = Spices.(default |> fg (color "#992222") |> build) fmt

type s = { counter : int; keys : string list }

let init _ = Command.Noop
let initial_model () = { counter = 0; keys = [] }

let update event model =
  match event with
  | Event.KeyDown "q" -> (model, Command.Quit)
  | Event.KeyDown k ->
      let k = if k = "space" then " " else k in
      let model = { counter = model.counter + 1; keys = model.keys @ [ k ] } in
      (model, Command.Noop)
  | _ -> (model, Command.Noop)

let view model =
  if model.counter = -1 then keyword "goodbye!"
  else
    let first_6 =
      model.keys |> List.to_seq |> Seq.take 6 |> List.of_seq |> String.concat ""
    in
    let rest =
      model.keys |> List.to_seq |> Seq.drop 6 |> List.of_seq |> String.concat ""
    in
    keyword "%d" model.counter ^ " " ^ first_6 ^ red "%s" rest

let app = Minttea.app ~initial_model ~init ~update ~view ()
let () = Minttea.start app