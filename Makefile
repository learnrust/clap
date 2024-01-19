#
# Considerations
# - Easy to debug: show the command being run
# - Leverage CI features: Only run individual steps so we can use features like reporting elapsed time per step

ARGS?=--workspace
TOOLCHAIN_TARGET ?=
ifneq (${TOOLCHAIN_TARGET},)
  ARGS+=--target ${TOOLCHAIN_TARGET}
endif

MSRV?=1.60.0

_FEATURES = minimal default wasm full debug release
_FEATURES_minimal = --no-default-features --features "std"
_FEATURES_default =
_FEATURES_wasm = --features "deprecated derive cargo env unicode string unstable-replace unstable-grouped"
_FEATURES_full = --features "deprecated derive cargo env unicode string unstable-replace unstable-grouped wrap_help"
_FEATURES_next = ${_FEATURES_full} --features unstable-v5
_FEATURES_debug = ${_FEATURES_full} --features debug --features clap_complete/debug
_FEATURES_release = ${_FEATURES_full} --release

check-%:
	cargo check ${_FEATURES_${@:check-%=%}} --all-targets ${ARGS}

build-%:
	cargo test ${_FEATURES_${@:build-%=%}} --all-targets --no-run ${ARGS}

test-%:
	cargo test ${_FEATURES_${@:test-%=%}} ${ARGS}

clippy-%:
	cargo clippy ${_FEATURES_${@:clippy-%=%}} ${ARGS} --all-targets -- -D warnings -A deprecated

test-ui-%:
	cargo +${MSRV} test --test derive_ui --features derive ${_FEATURES_${@:test-ui-%=%}}

doc:
	cargo doc --workspace --all-features --no-deps --document-private-items

# added by tjyang
.PHONY: examples push
_FEATURES4 = --features="derive" --features="cargo" 
_DEBUG4 = target/debug/examples

push:
	(git commit -a -m "lazy committing message" && git push)
cargo-example:
	cargo build ${_FEATURES4} --example cargo-example && ${_DEBUG4}/cargo-example -h
examples:
	cargo build ${_FEATURES4} --example cargo-example-derive && ${_DEBUG4}/cargo-example-derive   -h
	cargo build ${_FEATURES4} --example demo && ${_DEBUG4}/demo        -h
	cargo build ${_FEATURES4} --example find && ${_DEBUG4}/find        
	cargo build ${_FEATURES4} --example pacman && ${_DEBUG4}/pacman -h
#	cargo build ${_FEATURES4} --example git && ${_DEBUG4}/git 
#	cargo build ${_FEATURES4} --example repl && ${_DEBUG4}/repl -h
	cargo build ${_FEATURES4} --example typed-derive && ls -l ${_DEBUG4}/typed-derive 
	cargo build ${_FEATURES4} --example escaped-positional-derive && ls -l ${_DEBUG4}/escaped-positional-derive 
	cargo build ${_FEATURES4} --example escaped-positional && ${_DEBUG4}/escaped-positional 
	cargo build ${_FEATURES4} --example git-derive			    && ${_DEBUG4}/git-derive		   	  help
	cargo build ${_FEATURES4} --example typed-derive		&& ${_DEBUG4}/typed-derive		      
	cargo build ${_FEATURES4} --example busybox			&& ${_DEBUG4}/busybox help			      
#	cargo build ${_FEATURES4} --example hostname			&& ${_DEBUG4}/hostname			      
#	cargo build ${_FEATURES4} --example repl			&& ${_DEBUG4}/repl			      
	cargo build ${_FEATURES4} --example 01_quick			&& ${_DEBUG4}/01_quick			      
	cargo build ${_FEATURES4} --example 02_apps			&& ${_DEBUG4}/02_apps	--two 2 --one 1		      
	cargo build ${_FEATURES4} --example 02_crate			&& ${_DEBUG4}/02_crate	 --two 2 --one 1		      
	cargo build ${_FEATURES4} --example 02_app_settings		&& ${_DEBUG4}/02_app_settings	 --two 2 --one 1 	
	cargo build ${_FEATURES4} --example 03_01_flag_bool		&& ${_DEBUG4}/03_01_flag_bool		      
	cargo build ${_FEATURES4} --example 03_01_flag_count		&& ${_DEBUG4}/03_01_flag_count		      
	cargo build ${_FEATURES4} --example 03_02_option		&& ${_DEBUG4}/03_02_option		      
	cargo build ${_FEATURES4} --example 03_02_option_mult		&& ${_DEBUG4}/03_02_option_mult	   	   
	cargo build ${_FEATURES4} --example 03_03_positional		&& ${_DEBUG4}/03_03_positional		      
	cargo build ${_FEATURES4} --example 03_03_positional_mult	&& ${_DEBUG4}/03_03_positional_mult	      
	cargo build ${_FEATURES4} --example 03_04_subcommands		&& ${_DEBUG4}/03_04_subcommands	   	   -h
	cargo build ${_FEATURES4} --example 03_05_default_values	&& ${_DEBUG4}/03_05_default_values	      
	cargo build ${_FEATURES4} --example 04_01_possible		&& ${_DEBUG4}/04_01_possible		      -h
	cargo build ${_FEATURES4} --example 04_01_enum			    && ${_DEBUG4}/04_01_enum		   	-h    
	cargo build ${_FEATURES4} --example 04_02_parse			    && ${_DEBUG4}/04_02_parse		   	-h    
	cargo build ${_FEATURES4} --example 04_02_validate		&& ${_DEBUG4}/04_02_validate		      	-h 
	cargo build ${_FEATURES4} --example 04_03_relations		&& ${_DEBUG4}/04_03_relations		      	-h 
	cargo build ${_FEATURES4} --example 04_04_custom		&& ${_DEBUG4}/04_04_custom		      	-h 
	cargo build ${_FEATURES4} --example 05_01_assert		&& ${_DEBUG4}/05_01_assert		      	-h 
	cargo build ${_FEATURES4} --example 01_quick_derive		&& ${_DEBUG4}/01_quick_derive		      	-h 
	cargo build ${_FEATURES4} --example 02_apps_derive		&& ${_DEBUG4}/02_apps_derive		      	-h 
	cargo build ${_FEATURES4} --example 02_crate_derive		&& ${_DEBUG4}/02_crate_derive		      	-h 
	cargo build ${_FEATURES4} --example 02_app_settings_derive	&& ${_DEBUG4}/02_app_settings_derive	      	-h 
	cargo build ${_FEATURES4} --example 03_01_flag_bool_derive	&& ${_DEBUG4}/03_01_flag_bool_derive	      	-h 
	cargo build ${_FEATURES4} --example 03_01_flag_count_derive	&& ${_DEBUG4}/03_01_flag_count_derive	      	-h 
	cargo build ${_FEATURES4} --example 03_02_option_derive		    && ${_DEBUG4}/03_02_option_derive	   	-h    
	cargo build ${_FEATURES4} --example 03_02_option_mult_derive		    && ${_DEBUG4}/03_02_option_mult_derive      -h	      
	cargo build ${_FEATURES4} --example 03_03_positional_derive		    && ${_DEBUG4}/03_03_positional_derive	-h      
	cargo build ${_FEATURES4} --example 03_03_positional_mult_derive	    && ${_DEBUG4}/03_03_positional_mult_derive  -h 
	cargo build ${_FEATURES4} --example 03_04_subcommands_derive		    && ${_DEBUG4}/03_04_subcommands_derive	-h      
	cargo build ${_FEATURES4} --example 03_04_subcommands_alt_derive	    && ${_DEBUG4}/03_04_subcommands_alt_derive  -h 
	cargo build ${_FEATURES4} --example 03_05_default_values_derive	    && ${_DEBUG4}/03_05_default_values_derive    	-h
	cargo build ${_FEATURES4} --example 04_01_enum_derive		    && ${_DEBUG4}/04_01_enum_derive	   	   	-h
	cargo build ${_FEATURES4} --example 04_02_parse_derive		    && ${_DEBUG4}/04_02_parse_derive	   	   	-h
	cargo build ${_FEATURES4} --example 04_02_validate_derive		    && ${_DEBUG4}/04_02_validate_derive	      	-h
	cargo build ${_FEATURES4} --example 04_03_relations_derive		    && ${_DEBUG4}/04_03_relations_derive	-h      
	cargo build ${_FEATURES4} --example 04_04_custom_derive		    && ${_DEBUG4}/04_04_custom_derive	   	   	-h
	cargo build ${_FEATURES4} --example 05_01_assert_derive		    && ${_DEBUG4}/05_01_assert_derive	   	   	-h
	cargo build ${_FEATURES4} --example interop_augment_args		    && ${_DEBUG4}/interop_augment_args	      	-h
	cargo build ${_FEATURES4} --example interop_augment_subcommands	    && ${_DEBUG4}/interop_augment_subcommands    	-h
	cargo build ${_FEATURES4} --example interop_hand_subcommand		    && ${_DEBUG4}/interop_hand_subcommand	-h      
	cargo build ${_FEATURES4} --example interop_flatten_hand_args   	    && ${_DEBUG4}/interop_flatten_hand_args     -h
sub01:
	cargo build ${_FEATURES4} --example interop_augment_subcommands	    && ${_DEBUG4}/interop_augment_subcommands    	-h
clean:
	cargo clean
