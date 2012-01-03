#!/usr/bin/env coffee
request = require 'request'

months = [
  'January'
  'February'
  'March'
  'April'
  'May'
  'June'
  'July'
  'August'
  'September'
  'October'
  'November'
  'December'
]

urls = {}

retrieve = (dateStr, appId) ->

  date = new Date dateStr
  getResults 0, appId, date


getResults = (offset, appId, date) ->

  year = date.getFullYear()
  month = months[date.getMonth()]
  day = date.getDate()

  url = "http://api.bing.net/json.aspx?AppId=#{appId}&query=site%3abbc.co.uk%2fnews+%22#{day}+#{month}+#{year}+last+updated%22&sources=web&web.count=50&web.offset=#{offset}"
  request url, (error, response, body) ->

    if not error and response.statusCode is 200
      info = JSON.parse body

      total =  info.SearchResponse.Web.Total
      offset =  info.SearchResponse.Web.Offset
      results = info.SearchResponse.Web.Results

      if results
        for result in results
          if result.DisplayUrl.match /.*\-[0-9]+/
            urls[result.DisplayUrl] = result.DisplayUrl
 
        if (offset + results.length < total)
          getResults offset+results.length+1, appId, date
        else
          for url,dummy of urls
            console.log url


if not module.parent
  # Take a date from the command line and process it
  date = new Date process.argv[2]
  appId = process.argv[3]

  retrieve date, appId

else
   module.exports.retrieve = retrieve

