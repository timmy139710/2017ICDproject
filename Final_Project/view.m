iclear
fid=fopen('memory_hex.txt');
A=fscanf(fid,'%s  ');  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
fclose(fid);
a = zeros(128);
for i=1:16384
    if(A(i*2-1)~='x'&&A(i*2)~='x')
        a(ceil(i/128),mod(i,128)) = hex2dec( A(i*2-1:i*2));
    else
        a(ceil(i/128),mod(i,128)+1)=0;
    end

end
figure(1)
imshow(uint8(a))
