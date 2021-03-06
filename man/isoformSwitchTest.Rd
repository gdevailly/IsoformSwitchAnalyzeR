\name{isoformSwitchTest}
\alias{isoformSwitchTest}

\title{
Statistical Test of Isoform Switching.
}
\description{
This function performs a statistical test (see details) for each isoforms (isoform resolution) and conditions stored in the \code{switchAnalyzeRlist} object.
}
\usage{
isoformSwitchTest(
    switchAnalyzeRlist,
    alpha=0.05,
    dIFcutoff = 0.1,
    reduceToSwitchingGenes = TRUE,
    calibratePvalues=TRUE,
    showProgress=FALSE,
    quiet=FALSE
)
}

\arguments{
  \item{switchAnalyzeRlist}{ A \code{switchAnalyzeRlist} object. }

  \item{alpha}{
The cutoff which the (calibrated) fdr correct p-values must be smaller than for calling significant switches. Defuault is 0.05.
}

\item{dIFcutoff}{
The cutoff which the changes in (absolute) isoform usage must be larger than before an isoform is considered switching. This cutoff can remove cases where isoforms with (very) low dIF values are deemed significant and thereby included in the downstream analysis. This cutoff is analogous to having a cutoff on log2 fold change in a normal differential expression analysis of genes to ensure the genes have a certain effect size. Default is 0.1 (10\%).
}

  \item{reduceToSwitchingGenes}{
A logic indicating whether the switchAnalyzeRlist should be reduced to the genes which contains significant switching (as indicated by the \code{alpha} and \code{dIFcutoff} parameters). Enabling this will make the downstream analysis a lot faster since fewer genes needs to be analyzed. Default is TRUE.
}

  \item{calibratePvalues}{
A logic indicating whether the p-values should be calibrated according to the methods in Ferguson et al (2014), this will only be done if the p-value distribution is very skewed (if the estimated sigma^2 values is < 0.9) as suggested by the authors. See details for more information. Default is TRUE.
}

\item{showProgress}{
A logic indicating whether to make a progress bar (if TRUE) or not (if FALSE). Defaults is FALSE.
}

\item{quiet}{ A logic indicating whether to avoid printing progress messages (incl. progress bar). Default is FALSE}
}

\details{
Changes in isoform usage are measure as the difference in isoform fraction (dIF) values, where isoform fraction (IF) values are calculated as <isoform_exp> / <gene_exp>. \cr

The idea behind test implemented in \code{isoformSwitchTest} can be explained as a three step process:
\itemize{
\item{\code{1} : Use the uncertainty (e.g. variance ) of gene and isoform expression estimats (obtained via biological replicates) to estimate the uncertainty of the isoform fraction (e.g. the variance of the IF values).}
\item{\code{2} : Use the uncertainty of the IF estimate to statistically test the validity of the changes in isoform usage between conditions.}
\item{\code{3} : (calibrate p-values and) correct for multiple testing}
}

The procedure implemented here  to esitmating the uncertainty of IF values (e.g. the variance of the IF values) is only robust when the gene expression is not close to zero. When the gene expression is to close to zero the variance estimate becomes untrustworthy. To prevent this we have implemented a hardcoded filter that only allows estimation of the IF variance (and thereby testing of an isoform) if the 95\% confidence intervals (CI) of the gene expression (in both conditions) is larger than zero. The 95\% CI is calculated via the t-distribution thereby taking sample size into account.\cr

The p-value calibration, if enabled, is only performed if the sigma^2 (sigma squared) estimated from the top 50\% expressed data is smaller than 0.9 in accordance with the guidelines suggested by the author.\cr

For full description please see the methods section of Vitting-Seerup et al 2017.
}

\value{
A \code{switchAnalyzeRlist} where the following have been modified:
\itemize{
    \item{\code{1}: Two collumns, \code{isoform_switch_q_value} and \code{gene_switch_q_value} in the \code{isoformFeatures} entry have been filled out summarizing the result of the above described test.}
    \item{\code{2}: A \code{data.frame} containing the details of the analysis have been added (called 'isoformSwitchAnalysis').}
}

The data.frame added have one row per isoform per comparison of condition and contains the following columns:
\itemize{
    \item{\code{iso_ref} : A unique refrence to a specific isoform in a specific comaprison of conditions. Enables easy handles to integrate data from all the parts of a \code{switchAnalyzeRlist}.}
    \item{\code{gene_ref} : A unique refrence to a specific gene in a specific comaprison of conditions. Enables esay handles to integrate data from all the parts of a \code{switchAnalyzeRlist}.}
    \item{\code{isoform_id}: The name of the isoform analyzed. Matches the 'isoform_id' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{gene_id}: The id of the gene which the isoform_id belongs to. Matches the 'gene_id' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{condition_1}: The first condition of the comparison. Should be though of as the ground state - meaning the changes occure  from condition_1 to condition_2. Matches the 'condition_1' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{condition_2}: The second condition of the comparison. Should be though of as the changed state - meaning the changes occure  from condition_1 to condition_2. Matches the 'condition_2' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{nrReplicates_1}: The number of biological replicates in condition_1. Matches the 'nrReplicates_1' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{nrReplicates_2}: The number of biological replicates in condition_2. Matches the 'nrReplicates_2' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{IF1}: The isoform fraction value (IF) of the isoform_id in condition_1. Matches the 'IF1' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{IF2}: The isoform fraction value (IF) of the isoform_id in condition_2. Matches the 'IF2' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{IF_var_1}: The variance of IF1 measured from the nrReplicates_1 biological replicates. Matches the 'IF_var_1' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{IF_var_2}: The variance of IF2 measured from the nrReplicates_2 biological replicates. Matches the 'IF_var_2' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{dIF}: The difference in the IF values measured as IF2-IF1 meaning that postive values means the isoform is used more in condition_2 and vice versa. Matches the 'dIF' entry in the 'isoformFeatures' entry of the switchAnalyzeRlist}
    \item{\code{dIF_std_err}: The standard error of the dIF value.}
    \item{\code{t_statistics}: The test t-statistics. See Vitting-Seerup et al 2017 for details.}
    \item{\code{deg_free}: The degrees of freedome used to calculate the p_value of the statistical test. See Vitting-Seerup et al 2017 for details.}
    \item{\code{p_value}: The raw p-value from the statistical test implemented in IsoformSwitchAnalyzeR. See Vitting-Seerup et al 2017 for details.}
    \item{\code{calibrated_p_values}: The transformed/callibrated p-values. See Ferguson et al 2014 for more details. Will only be calculated if \code{calibratePvalues=TRUE} and the sigma^2 (sigma squared) estimated from the top 50\% expressed data is smaller than 0.9 in accordance with the guidelines suggested by the author. If NA the callibarion was not performed.}
    \item{\code{iso_switch_q_value}: The FDR corrected p-values. If the p-value callibration was perfomed these are naturally the FDR corrected callibrated p-values.}
    \item{\code{gene_switch_q_value}: The gene-level evidence for an isoform swich occuring. Defined as the smallest iso_switch_q_value of the isoforms belonging to the gene_id.}
}
}

\references{
\itemize{
    \item{Vitting-Seerup et al. The Landscape of Isoform Switches in Human Cancers. Mol. Cancer Res. (2017).}
    \item{Ferguson JP, Palejev D: P-value calibration fro multiple testing problems in genomics. Stat. Appl. Genet. Mol. Biol. 2014, 13:659-673.}
}
}

\author{
Kristoffer Vitting-Seerup
}
\seealso{
\code{\link{preFilter}}\cr
\code{\link{extractSwitchSummary}}\cr
\code{\link{extractTopSwitches}}
}
\examples{
# Load example data and prefilter
data("exampleSwitchList")
exampleSwitchList <- preFilter(exampleSwitchList)

# Perfom test
exampleSwitchListAnalyzed <- isoformSwitchTest(exampleSwitchList)

# extract summary of number of switching features
extractSwitchSummary(exampleSwitchListAnalyzed)

# extract whether p-value callibration was performed
extractCalibrationStatus(exampleSwitchListAnalyzed)
}
