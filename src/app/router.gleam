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
  catch_error({
    use hero <- result.try(tagg.render(ctx.tagg, "hero.html", cx.dict()))
    use about <- result.try(tagg.render(ctx.tagg, "about.html", cx.dict()))
    use main <- result.try(wrap_content(hero <> about, ctx))
    Ok(main)
  })
}

fn legal_page(_req: Request, ctx: Context) -> Response {
  tagg.render(ctx.tagg, "legal.html", cx.dict())
  |> result.map(wrap_content(_, ctx))
  |> result.flatten()
  |> catch_error()
}

fn telegram(_req: Request) -> Response {
  wisp.redirect("https://t.me/+kDp_-2NZOVY0OThh")
}

fn wrap_content(content: String, ctx: Context) {
  cx.dict()
  |> cx.add_string("content", content)
  |> tagg.render(ctx.tagg, "shell.html", _)
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
