// Ack-Gated Canary Rollout — pure net (no guards)

store repo            // commit(sha)
store artifacts       // build(sha)
store images          // image(sha)
store registry        // img(sha)

store staging         // deployed(sha)
store ready           // sha

store prod            // active(sha) | canary(sha)
store retired         // retired(sha)

store prod_pool       // slot | hold

store io_tx           // send(cmd)
store io_rx           // ack(cmd)
store inflight        // pending(cmd)

store health          // ok(sha) | fail(sha)
store approval        // release(sha)
store log             // event(...)

transition build {
  in  repo(commit(let sha))
  out artifacts(build(let sha))
  out log(event(build_done(let sha)))
}

transition publish_image {
  in  artifacts(build(let sha))
  out images(image(let sha))
  out log(event(image_built(let sha)))
}

transition push_registry {
  in  images(image(let sha))
  out registry(img(let sha))
  out log(event(pushed(let sha)))
}

// send apply(staging, sha)
transition deploy_staging_send {
  in  registry(img(let sha))
  out io_tx(send(apply(staging, let sha)))
  out inflight(pending(apply(staging, let sha)))
  out log(event(staging_apply_sent(let sha)))
}

transition deploy_staging_ack {
  in  io_rx(ack(apply(staging, let sha)))
  in  inflight(pending(apply(staging, let sha)))
  out staging(deployed(let sha))
  out log(event(staging_deployed(let sha)))
}

transition health_gate {
  in  staging(deployed(let sha))
  in  health(ok(let sha))
  out ready(let sha)
  out log(event(health_pass(let sha)))
}

transition canary_start {
  in  ready(let sha)
  in  prod_pool(slot)
  out prod(canary(let sha))
  out prod_pool(hold)
  out log(event(canary_started(let sha)))
}

transition canary_promote {
  in  prod(canary(let new))
  in  prod(active(let old))
  in  approval(release(let new))
  in  prod_pool(hold)
  out prod(active(let new))
  out retired(let old)
  out prod_pool(slot)
  out log(event(promoted(let new, let old)))
}

init {
  repo commit(v1)

  io_rx  ack(apply(staging, v1))
  health ok(v1)
  approval release(v1)

  prod_pool slot * 3
  prod active(v0)
}
