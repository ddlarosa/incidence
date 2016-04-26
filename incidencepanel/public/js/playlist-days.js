// TODO: create an object instead of having global variables and standalone functions

// external configuration variables
var pldays_url_prefix = '';
var pldays_init_cb = undefined;

// internal status tracking variables
var pldays_initialized = false;
var pldays_hash = {};


// query for pl days and call datepicker init function if needed
function fetch_pldays(year, month)
{
    var now = new Date();
    if (year == undefined)
        year = now.getFullYear();
    if (month == undefined)
        month = now.getMonth() + 1;

    var url = pldays_url_prefix + year + '/' + month + '.json';
    $.getJSON(url,
              function(data){
                  for (var key in data){
                      // use hasOwnProperty to filter out keys from the Object.prototype
                      if (data.hasOwnProperty(key)) {
                          pldays_hash[key] = data[key];
                      }
                  }
                  if (! pldays_initialized && pldays_init_cb != undefined)
                  {
                      pldays_initialized = true;
                      pldays_init_cb();
                  }
              });
}


// runs for every day displayed in datepicker
function highlight_pldays(date)
{
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var date_str = sdf.format(date);
    var res;

    if (pldays_hash[date_str] == 1)
    {
        res = [true, 'day-with-pl-ok', 'there\'s a playlist ready for this day'];
    }
    else if (pldays_hash[date_str] == 2)
    {
        res = [true, 'day-with-pl-nofiles', 'there\'s a playlist with missing files for this day'];
    }
    else if (pldays_hash[date_str] == 3)
    {
        res = [true, 'day-with-pl-empty', 'there\'s a playlist for this day, but it\'s empty'];
    }
    else
    {
        res = [true, 'day-without-pl', 'there\'s no playlist for this day'];
    }

    // returned array:
    // [0] = true | false if this day is selectable
    // [1] = css class to add
    // [2] = tooltip to display
    return res;
}
