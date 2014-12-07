county_names = {'alameda' 'alpine' 'amader' 'butte' 'calaveras' 'colusa' 'contracosta' 'delnorte' 'eldorado' 'fresno' 'glenn' 'humboldt' 'imperial' 'inyo' 'kern' 'kings' 'lake' 'lassen' 'losangeles' 'madera' 'marin' 'mariposa' 'mendocino' 'merced' 'modoc' 'mono' 'monterey' 'napa' 'nevada' 'orange' 'placer' 'plumas' 'riverside' 'sacto' 'sanbenito' 'sanbernardino' 'sandiego' 'sanfrancisco' 'sanjoaquin' 'sanluisobispo' 'sanmateo' 'santabarbara' 'santaclara' 'santacruz' 'shasta' 'sierra' 'siskiyou' 'solano' 'sonoma' 'stanislaus' 'sutter' 'tehama' 'trinity' 'tulare' 'tuolumne' 'ventura' 'yolo' 'yuba'};
[~, county_num] = size(county_names);

legend = [11 12 21 22 23 24 31 41 42 43 51 52 71 72 73 74 81 82 90 95];
[~, s_leg] = size(legend);

offset_2006 = 1; %january 1,2006
offset_2011 = offset_2006 + 365*5; %January 1,2011

target_start = 1; %January 1, 2006
target_end = 2920; %December 30, 2013

for j = 1:county_num
    file_2011 = [county_names{j} '_2011.csv'];
    file_2006 = [county_names{j} '_2006.csv'];
    file_out = ['data_' county_names{j} '.csv'];

    fid = fopen(file_2011);
    filCont = textscan(fid,'%s','delimiter','\n');
    fclose(fid);

    data_2011 = filCont{1};
    data_2011 = data_2011(2:end);
    [s_2011, ~] = size(data_2011);

    fid = fopen(file_2006);
    filCont = textscan(fid,'%s','delimiter','\n');
    fclose(fid);

    data_2006 = filCont{1};
    data_2006 = data_2006(2:end);
    [s_2006, ~] = size(data_2006);

    feature_counts_2011 = zeros(1,s_leg);
    feature_counts_2006 = zeros(1,s_leg);

    for i = 1:s_2011
        curr_line=cell2mat(data_2011(i));
        value_id_parser = textscan(curr_line,'%f','delimiter',',');
        value_count_parser = textscan(curr_line,'%s','delimiter','"');
        value_id = value_id_parser{1}(2);
        value_count=value_count_parser{1}{2};
        value_count = str2num(value_count(value_count~=','));
        ind = find(legend==value_id);
        feature_counts_2011(ind) = value_count;
    end

    for i = 1:s_2006
        curr_line=cell2mat(data_2006(i));
        value_id_parser = textscan(curr_line,'%f','delimiter',',');
        value_count_parser = textscan(curr_line,'%s','delimiter','"');
        value_id = value_id_parser{1}(2);
        value_count=value_count_parser{1}{2};
        value_count = str2num(value_count(value_count~=','));
        ind = find(legend==value_id);
        feature_counts_2006(ind) = value_count;
    end

    data_x = [target_start:target_end]';
    feature_data = zeros(target_end,s_leg);

    for i = 1:s_leg
        feature_data(:,i) = interp1([offset_2006;offset_2011],[feature_counts_2006(i);feature_counts_2011(i)],data_x,'linear','extrap');
    end
    feature_sum = sum(feature_data,2);
    feature_out = bsxfun(@rdivide,feature_data,feature_sum);

    csvwrite(file_out,feature_out);
end

