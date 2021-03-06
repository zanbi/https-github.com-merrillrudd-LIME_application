run_model_set <- function(dir, LC, lh, add_years=0, S_l_input=-1, C_t=NULL, I_t=NULL, F_up=5, est_sigma="log_sigma_R", fix_param=FALSE, param_adjust=FALSE, val_adjust=FALSE, data_avail="LC", rerun=TRUE, randomR=TRUE, theta_type=0, lc_ylim=NULL, plot=TRUE){
	
	years_o <- as.numeric(rownames(LC))
	years_m <- (min(years_o)-add_years):max(years_o)

	input_data <- list("years"=years_m, "LF"=LC, "C_t"=C_t, I_t=I_t)


		if(file.exists(file.path(dir, "LBSPR_results.rds"))==FALSE | rerun==TRUE){
				run <- run_LBSPR(modpath=dir, lh=lh, species="x", input_data=input_data, rewrite=TRUE, simulation=FALSE)	
				lbspr_res <- readRDS(file.path(dir, "LBSPR_results.rds"))
		}

		if(file.exists(file.path(dir, "Report.rds"))==FALSE | rerun==TRUE){
			res <- run_LIME(modpath=dir, lh=lh, input_data=input_data, est_sigma=est_sigma, data_avail=data_avail, LFdist=1, simulation=FALSE, rewrite=TRUE, S_l_input=S_l_input, F_up=F_up, fix_param=fix_param, param_adjust=param_adjust, val_adjust=val_adjust, randomR=randomR, theta_type=theta_type)
		}

		if(file.exists(file.path(dir, "Report.rds"))){
			if(file.exists(file.path(dir, "LBSPR_results.rds"))) lbspr_res <- readRDS(file.path(dir, "LBSPR_results.rds"))
			if(file.exists(file.path(dir, "LBSPR_results.rds"))==FALSE) lbspr_res <- NULL
				
			Report <- readRDS(file.path(dir, "Report.rds"))
			Sdreport <- readRDS(file.path(dir, "Sdreport.rds"))
			Inputs <- readRDS(file.path(dir, "Inputs.rds"))

		if(plot==TRUE){
			png(file.path(dir, "output.png"), width=16, height=10, res=200, units="in")
			plot_output(Inputs=Inputs, Report=Report, Sdreport=Sdreport, all_years=input_data$years, lc_years=rownames(input_data$LF), LBSPR=lbspr_res)
			dev.off()	

			png(file.path(dir, "LCfits.png"), width=16, height=10, res=200, units="in")
			plot_LCfits(Inputs=Inputs$Data, Report=Report, true_lc_years=rownames(input_data$LF), LBSPR=lbspr_res, ylim=lc_ylim)
			dev.off()
		}
		}

}