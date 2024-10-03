import app/web.{type Context}
import cx
import gleam/io
import gleam/result
import gleam/string_builder
import tagg
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use _req <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> main_page(req, ctx)
    ["legal"] -> legal_page(req, ctx)
    ["telegram"] -> telegram(req)
    _ -> wisp.not_found()
  }
}

fn main_page(_req: Request, ctx: Context) -> Response {
  case tagg.render(ctx.tagg, "main_page.html", cx.dict()) {
    Ok(html) -> {
      wisp.ok()
      |> wisp.html_body(string_builder.from_string(html))
    }
    Error(err) -> {
      io.debug(err)
      wisp.internal_server_error()
    }
  }
}

fn legal_page(_req: Request, ctx: Context) -> Response {
  tagg.render(ctx.tagg, "legal.html", cx.dict())
  |> result.map(fn(legal) {
    cx.dict()
    |> cx.add_string("content", legal)
    |> tagg.render(ctx.tagg, "shell.html", _)
  })
  |> result.flatten()
  |> catch_error()
}

fn telegram(_req: Request) -> Response {
  wisp.redirect("https://t.me/+kDp_-2NZOVY0OThh")
}

fn catch_error(result: Result(String, whatever)) -> Response {
  case result {
    Ok(html) -> {
      wisp.ok()
      |> wisp.html_body(string_builder.from_string(html))
    }
    Error(err) -> {
      io.debug(err)
      wisp.internal_server_error()
    }
  }
}
