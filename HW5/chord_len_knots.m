function knot_values = chord_len_knots(data_pnts)


[num_pnts dim] = size(data_pnts); 

chords = zeros(1,num_pnts-1);

%calculate chord lengths
for i = 1:num_pnts-1
    chords(i) = sqrt(sum((data_pnts(i+1,:)-data_pnts(i,:)).^2));
end

%get the un-normalized knot values
knots = zeros(1,num_pnts);
for i = 2:num_pnts
    knots(i)= sum(chords(1:i-1));
end

%normalize and return
knot_values = knots./sum(chords);