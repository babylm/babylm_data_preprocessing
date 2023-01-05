ROOT=/scratch/asw462/shared_task/data_preprocessing
mkdir tmp
DATA_DIR=$ROOT/tmp/bnc_spoken
mkdir $DATA_DIR
cd $DATA_DIR
curl https://llds.ling-phil.ox.ac.uk/llds/xmlui/bitstream/handle/20.500.14106/2554/2554.zip > bnc.zip
unzip -q bnc.zip
rm bnc.zip
for z in download/Texts/*; do 
	for y in $z/*; do 
		for x in $y/*; do 
			sed '2q;d' $x | grep "^<stext" -q && cp $x ${DATA_DIR}
		done; 
	done; 
done;
rm -rf download

python preprocess_bnc.py tmp/bnc_spoken/ bnc_spoken.txt
rm -rf tmp/bnc_spoken

