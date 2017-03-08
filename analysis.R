# analysing the python interpreter startup speed
# experiment done during a downtime.
# This was meant to test the size of the "python import"
# problem and comparing the speed of starting concurrent
# python interpreters using standard anaconda environments
# vs. singularity containerized python

# i started n python interpreters on N nodes each and measured
# how fast the n started on each node and also how fast all of them
# started (i.e. from the first one starting to the last one finishing).

###
### setup
###

library(ggplot2)

###
### the overall time (i.e. the latter)
###

# read the data
ot <- read.table("overall_time.bcp", sep="|",
                colClasses = c("factor", "integer", "integer", "integer", "numeric"),
                col.names = c("interpreter", "n.per.node", "n.nodes","n.total", "time.s"))

p <- ggplot(ot) +
  geom_point(aes(x=n.total, y=time.s), size=1.5, color="black") +
  geom_point(aes(x=n.total, y=time.s, color=interpreter),
             size=1) +
  geom_smooth(aes(x=n.total, y=time.s, color=interpreter), se=FALSE) +
  scale_color_brewer(palette="Set1") +
  labs(x = "Total number of concurrent interpreters",
       y = "Total time [s]") +
  theme_bw(16)
ggsave(p, file="overall_time.png")

p <- ggplot(ot) +
  geom_point(aes(x=n.total, y=time.s), size=1.5, color="black") +
  geom_point(aes(x=n.total, y=time.s, color=interpreter),
             size=1) +
  geom_smooth(aes(x=n.total, y=time.s, color=interpreter), se=FALSE) +
  scale_color_brewer(palette="Set1") +
  scale_x_log10() +
  scale_y_log10() +
  labs(x = "Total number of concurrent interpreters",
       y = "Total time [s]") +
  theme_bw(16) + theme(panel.grid.minor = element_blank())
ggsave(p, file="overall_time_loglog.png")


###
### individual times
###

it <- read.table("individual_time.bcp", sep="|",
                 colClasses = c("factor", "integer", "integer", "integer", "numeric"),
                 col.names = c("interpreter", "n.per.node", "n.nodes","n.total", "time.s"))
it.ni <- it
it.ni$interpreter <- NULL

p <- ggplot(it) +
  geom_jitter(aes(x=n.total, y=time.s), alpha=0.1, color="grey80",
              data=it.ni) +
  geom_jitter(aes(x=n.total, y=time.s, color=interpreter), alpha=0.3) +
  geom_boxplot(aes(x=n.total, y=time.s, group=factor(n.total))) +
  scale_color_brewer(palette="Set1") +
  scale_x_log10() +
  scale_y_log10() +
  facet_wrap(~interpreter) +
  labs(x = "Total number of concurrent interpreters",
       y = "Total time [s]") +
  theme_bw(16)
ggsave(p, file="individual_time_loglog.png")
