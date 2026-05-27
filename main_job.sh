export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export PYTHONUNBUFFERED=1

mkdir -p logs

CUDA_VISIBLE_DEVICES=0 python -u codes/run.py \
	  --do_train --cuda --do_valid --do_test \
	    --data_path data/FB15k \
	      --model BoxTransE \
	        -n 128 -b 512 -d 400 -g 24 -a 1.0 \
		  -lr 0.0001 \
		    --max_steps 300000 \
		      --cpu_num 6 \
		        --test_batch_size 16 \
			  --center_reg 0.02 \
			    --geo box \
			      --task 1p.2p.3p.2i.3i.ic.ci \
			        --stepsforpath 300000 \
				  --offset_deepsets inductive \
				    --center_deepsets eleattention \
				      --print_on_screen \
				        > fb15k.log 2>&1 &

PID1=$!

CUDA_VISIBLE_DEVICES=1 python -u codes/run.py \
	  --do_train --cuda --do_valid --do_test \
	    --data_path data/FB15k-237 \
	      --model BoxTransE \
	        -n 128 -b 512 -d 400 -g 24 -a 1.0 \
		  -lr 0.0001 \
		    --max_steps 300000 \
		      --cpu_num 6 \
		        --test_batch_size 16 \
			  --center_reg 0.02 \
			    --geo box \
			      --task 1p.2p.3p.2i.3i.ic.ci \
			        --stepsforpath 300000 \
				  --offset_deepsets inductive \
				    --center_deepsets eleattention \
				      --print_on_screen \
				        > fb15k237.log 2>&1 &

PID2=$!

CUDA_VISIBLE_DEVICES=2 python -u codes/run.py \
	  --do_train --cuda --do_valid --do_test \
	    --data_path data/NELL \
	      --model BoxTransE \
	        -n 128 -b 512 -d 400 -g 24 -a 1.0 \
		  -lr 0.0001 \
		    --max_steps 300000 \
		      --cpu_num 6 \
		        --test_batch_size 16 \
			  --center_reg 0.02 \
			    --geo box \
			      --task 1p.2p.3p.2i.3i.ic.ci \
			        --stepsforpath 300000 \
				  --offset_deepsets inductive \
				    --center_deepsets eleattention \
				      --print_on_screen \
				        > nell.log 2>&1 &

PID3=$!

wait $PID1
wait $PID2
wait $PID3
