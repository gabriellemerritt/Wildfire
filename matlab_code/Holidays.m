H = holidays('jan 1 2006', 'dec 31 2013');

base_date = datenum('jan 1 2006') - 1;
num_dates = datenum('dec 31 2013') - datenum('jan 1 2006') + 1;

date_values = datenum('jan 1 2006'):datenum('dec 31 2013');
busdays = isbusday(date_values,[],[1 0 0 0 0 1 1]);

datestring = datestr(date_values');
offdays = abs(busdays-1);

file_out = ['holidays.csv'];
csvwrite(file_out,offdays);