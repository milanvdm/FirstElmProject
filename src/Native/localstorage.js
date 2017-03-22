
function store(data) {
    localStorage.setItem(data.key, data.value);
}

function retrieve(key) {
    return localStorage.getItem(key);
}