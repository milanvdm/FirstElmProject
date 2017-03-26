
'use strict'

const lsKey = 'FirstElmProject';

export function retrieve(key) {
  const item = localStorage.getItem(lsKey);
  if (item === null) {
    console.log("Localstorage does not contain " + lsKey)
    return "";
  }
  const json = JSON.parse(item)

  if (json.expires < Date.now()) {
    const value = json[key];
    if (value === null) {
        console.log("Localstorage does not contain " + key)
        return ""
    }
    return value
  }

  console.log("Localstorage expired")
  return "";
}

export function store(data) {
  const cacheItem = {
    expires: Date.now() + 600,
    [data.key]: data.value
  };
  localStorage.setItem(lsKey, JSON.stringify(cacheItem));
}
