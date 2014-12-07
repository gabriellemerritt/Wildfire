county_names = {'alameda' 'alpine' 'amador' 'butte' 'calaveras' 'colusa' 'contracosta' 'delnorte' 'eldorado' 'fresno' 'glenn' 'humboldt' 'imperial' 'inyo' 'kern' 'kings' 'lake' 'lassen' 'losangeles' 'madera' 'marin' 'mariposa' 'mendocino' 'merced' 'modoc' 'mono' 'monterey' 'napa' 'nevada' 'orange' 'placer' 'plumas' 'riverside' 'sacto' 'sanbenito' 'sanbernardino' 'sandiego' 'sanfrancisco' 'sanjoaquin' 'sanluisobispo' 'sanmateo' 'santabarbara' 'santaclara' 'santacruz' 'shasta' 'sierra' 'siskiyou' 'solano' 'sonoma' 'stanislaus' 'sutter' 'tehama' 'trinity' 'tulare' 'tuolumne' 'ventura' 'yolo' 'yuba'};
county_code = {'KOAK' 'KTVL' 'KPVF' 'KOVE' 'KO22' 'KMYV' 'KCCR' 'KCEC' 'KPVF' 'KFAT' 'KCIC' 'KEKA' 'KIPL' 'KBIH' 'KBFL' 'KHJO' 'KUKI' 'KRTS' 'KCQT' 'KMAE' 'KDVO' 'KMAE' 'KUKI' 'KMCE' 'KAAT' 'KBAN' 'KSNS' 'KAPC' 'KGOO' 'KSNA' 'KAUN' 'KBLU' 'KRAL' 'KSAC' 'KCVH' 'KSBD' 'KSAN' 'KSFO' 'KSCK' 'KSBP' 'KSQL' 'KSBA' 'KSJC' 'KWVI' 'KRDD' 'KBLU' 'KSIY' 'KSUU' 'KSTS' 'KMOD' 'KMYV' 'KRBL' 'KO54' 'KVIS' 'KO22' 'KOXR' 'KEDU' 'KBAB'};

[~,num_counties] = size(county_names);

urstart = 'http://www.wunderground.com/history/airport/';
urmid = '/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=';
urend = '&req_city=NA&req_state=NA&req_statename=NA&format=1';

NUM_FEATURES = 26;
NUM_TOGUST = 19;
NUM_PRECIP = 20;
NUM_COVER = 21;
NUM_EVENTS = 22;
NUM_FOG = 21;
NUM_RAIN = 22;
NUM_TSTORM = 23;
NUM_SNOW = 24;
NUM_DATE = 25;
BASE_DATE = datenum('jan 1 2006') - 1;
NUM_DAYS = datenum('dec 31 2013') - datenum('jan 1 2006') + 1;
NUM_EXISTS = 26;

cnty =1;
for cnty = 1:num_counties
    airport = county_code{cnty};
    name = county_names{cnty};

    data_mat = zeros(NUM_DAYS,NUM_FEATURES);
    for yr = 2006:2013
        year = int2str(yr);
        url = [urstart airport '/' year urmid year urend];
        filename = [name '_' year '.csv'];
        urlwrite(url,filename);

        fid = fopen(filename);
        data_curr = textscan(fid,'%s','delimiter','\n');
        fclose(fid);
        
        delete(filename);

        data = data_curr{1};
        data = data(3:end);
        [sz_data,~] = size(data);

        %Data Labels
        %MaxTemp,MeanTemp,MinTemp,MaxDew,MeanDew,MinDew,MaxHum,MeanHum,MinHum,
        %MaxPress,MeanPress,MinPress,MaxViz,MeanViz,MinViz,MaxWind,MeanWind
        %,WindGust,Precip,CloudCover,IsFog,IsRain,IsThunderstorms,IsSnow
        for dat = 1:sz_data
            curr_line = data{dat};
            weather_parser = textscan(curr_line,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%s%s','delimiter',',');
            [~,sz_parser] = size(weather_parser);
            
            %Fix this bit
            date = weather_parser{1};
            date = date{1};
            date_parser = textscan(date,'%s%s%s','delimiter','-');
            year = date_parser{1};
            month = date_parser{2};
            [~,sz_month] = size(month);
            day = date_parser{3};
            [~,sz_day] = size(day);
            if (sz_month==1)
                month{1} = ['0' month{1}];
            end
            if (sz_day==1)
                day{1} = ['0' day{1}];
            end
            date_parsed = [year{1} '-' month{1} '-' day{1}];
            date_serial = datenum(date_parsed,'yyyy-mm-dd');
            date_serial = date_serial-BASE_DATE;
            i = date_serial;
            
            data_mat(i,NUM_EXISTS) = 1;
            
            %Bulk
            for j = 2:NUM_TOGUST
                data_mat(i,(j-1)) = weather_parser{j};
            end

            %Precipitation
            pr_cell = weather_parser{NUM_PRECIP};
            precip = str2num(pr_cell{1});
            if(size(precip)==1)
                data_mat(i,NUM_PRECIP-1) = precip;
            else
                data_mat(i,NUM_PRECIP-1)=0;
            end

            %Cloud Cover
            data_mat(i,NUM_COVER-1) = weather_parser{NUM_COVER};   

            %Events
            events = weather_parser{NUM_EVENTS};
            if(size(events{1})~=0)
                events_cell = textscan(events{1},'%s','delimiter','-');
                events_list = events_cell{1};
                [sz_ev,~] = size(events_list);
                for z = 1:sz_ev
                    if (strcmp(events_list{z},'Fog'))
                        data_mat(i,NUM_FOG) = 1;
                    elseif (strcmp(events_list{z},'Snow'))
                        data_mat(i,NUM_SNOW) = 1;
                    elseif (strcmp(events_list{z},'Thunderstorms'))
                        data_mat(i,NUM_TSTORM) = 1;
                    elseif (strcmp(events_list{z},'Rain'))
                        data_mat(i,NUM_RAIN) = 1;
                    end
                end
            end
        end
    end
    file_out = ['weather_' name '.csv'];
    csvwrite(file_out,data_mat);
end