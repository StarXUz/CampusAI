package com.campusai.web.config;

import com.campusai.service.job.ClearUnusedImageJob;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

@Configuration
public class SchedulerConfig {
   @Bean
   public JobDetail clearUnusedImageJobDetail() {
      return JobBuilder.newJob(ClearUnusedImageJob.class).withIdentity("clearUnusedImageJob").storeDurably().build();
   }

   @Bean
   public Trigger clearUnusedImageTrigger(JobDetail clearUnusedImageJobDetail) {
      return TriggerBuilder.newTrigger().forJob(clearUnusedImageJobDetail).withIdentity("clearUnusedImageTrigger").withSchedule(CronScheduleBuilder.cronSchedule("0 0 2 * * ?")).build();
   }

   @Bean
   public SchedulerFactoryBean schedulerFactoryBean(AutowireCapableBeanFactory beanFactory, JobDetail clearUnusedImageJobDetail, Trigger clearUnusedImageTrigger) {
      SchedulerFactoryBean factoryBean = new SchedulerFactoryBean();
      factoryBean.setJobFactory(new AutowiringSpringBeanJobFactory(beanFactory));
      factoryBean.setJobDetails(new JobDetail[]{clearUnusedImageJobDetail});
      factoryBean.setTriggers(new Trigger[]{clearUnusedImageTrigger});
      return factoryBean;
   }
}
