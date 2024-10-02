import app/router
import app/web
import filepath
import gleam/dict
import gleam/erlang/process
import gleam/io
import mist
import simplifile
import tagg_config
import wisp
import wisp/wisp_mist

pub fn start_server(current_dir_path: String) {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  let tag_config = dict.from_list([])
  let ctx =
    web.Context(
      static_directory: static_directory(),
      tagg: tagg_config.Tagg(filepath.join(current_dir_path, "web"), tag_config),
    )

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, ctx), secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

pub fn static_directory() -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("howlseve_site")
  priv_directory <> "/static"
}

pub fn main() {
  case simplifile.current_directory() {
    Ok(current_dir_path) -> {
      start_server(current_dir_path)
    }
    Error(_) -> {
      io.println("Failed to get current directory")
    }
  }
}
