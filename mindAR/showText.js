const names = ['volkswagen', 'toyota', 'bmw', 'audi', 'porsche']

async function getJSON() {
    const response = await fetch('https://192.168.2.133:8443/brands/automarken.json')
    const json = await response.json()
    return json
}

async function fillText(brands) {
    for (const name of names) {
        var text = document.querySelector('#' + name + '_name')
        var info = document.querySelector('#' + name + '_info')
        text.setAttribute('value', brands[name]['name'])
        info.setAttribute('value', 'Gruendung: ' + brands[name]['year'] + '\n' + 'Sitz: ' + brands[name]['country'] + '\n' + 'Auto-Modell: ' + brands[name]['car'])
    }
}

getJSON().then(brands => {
    fillText(brands)
})

