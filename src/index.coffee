'use strict'

module.exports = (ndx) ->
  ndx.app.get '/api/impersonate/:userId', ndx.authenticate(['superadmin', 'admin', 'system']), (req, res, next) ->
    res.cookie 'impersonate', ndx.generateToken(ndx.user[ndx.settings.AUTO_ID], null), maxAge: 7 * 24 * 60 * 60 * 1000
    ndx.user[ndx.settings.AUTO_ID] = req.params.userId
    ndx.setAuthCookie req, res
    res.redirect '/'
  ndx.app.get '/api/unimpersonate', (req, res, next) ->
    ndx.user[ndx.settings.AUTO_ID] = ndx.parseToken req.cookies.impersonate
    res.clearCookie 'impersonate'
    ndx.setAuthCookie req, res
    res.redirect '/'