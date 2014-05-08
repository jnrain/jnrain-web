define [
], () ->
  'use strict'

  fullHourFromDate = (fromDate) ->
    # 直接对毫秒时间戳进行操作, 在可预见的将来这样都不会造成精度损失
    ts = +fromDate
    result = ts - ts % 3600000
    new Date(result)

  hoursLater = (refDate, hours) ->
    ts = +refDate
    new Date(ts + 3600000 * hours)

  # API
  fullHourFromDate: fullHourFromDate
  hoursLater: hoursLater


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
