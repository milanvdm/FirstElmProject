import { store, retrieve } from './localstorage';

/* global elmSettings */

function renderElm() {
  console.log("Starting Elm")

  const node = document.getElementById('app');

  if (node !== null) {

    const Elm = require('../Main.elm');
    console.log("Checking the localstorage")
    const app = Elm.Main.embed(node,
      {
        jwtToken: retrieve("jwtToken"),
      }
    );

    app.ports.store.subscribe(function(data) {
    store(data);
    });

    app.ports.retrieve.subscribe(function(key) {
        var value = retrieve(key);
        app.ports.loadLocalstorage.send(value);
    });

    return app;
  }
  return null;
}

export default renderElm;