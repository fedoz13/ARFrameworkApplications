const express = require('express')
const path = require('path')
const https = require('https')
const fs = require('fs')

const app = express()

app.set('/', 'html')
app.use(express.static(path.join(__dirname, '/')))
app.use('/brands', express.static(path.join(__dirname, 'brands')))
app.use(express.json())

https.createServer({
    key: fs.readFileSync("key.pem"),
    cert: fs.readFileSync("cert.pem"),
}, app).listen(8443)

app.get('/', function (req, res) {
    res.render('index')
})
