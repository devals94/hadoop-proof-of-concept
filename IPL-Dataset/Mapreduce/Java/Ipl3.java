package com.mpr;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import java.io.IOException;

public class Ipl3 {
public static class MyMapper extends Mapper<LongWritable, Text, Text,IntWritable> {
		
		public void map(LongWritable key, Text value, Context context ) throws IOException, InterruptedException {
				String MatchString = value.toString();
				String[] MatchData = MatchString.split( "," );
				int Toss_Winner = Integer.parseInt( MatchData[6] );
				context.write( new Text( "Toss Decision:\t"+MatchData[7].trim().toUpperCase()+"\tNo. of Times:" ), new IntWritable( Toss_Winner ) );
			}
		}//end of MyMapper class

public static class MyReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
	private IntWritable result = new IntWritable();
	public void reduce(Text key, Iterable<IntWritable> values, Context context ) throws IOException, InterruptedException {
		int sum = 0;
		for (IntWritable val : values) {
		sum += val.get();
		}
		result.set(sum);
		context.write(key, result);
		}
	}//end of MyReducer class


public static void main(String[] args) throws Exception {
Configuration conf = new Configuration();
Job job = new Job(conf, "Ipl3");
//Ignore the warning as new techniques for getting handle to Job is available now.
job.setJarByClass( Ipl3.class );
job.setMapperClass( MyMapper.class );
job.setReducerClass( MyReducer.class );
job.setMapOutputKeyClass( Text.class );
job.setMapOutputValueClass( IntWritable.class );
job.setOutputKeyClass( Text.class );
job.setOutputValueClass( IntWritable.class );
FileInputFormat.addInputPath( job, new Path( args[0] ) );
FileOutputFormat.setOutputPath( job, new Path( args[1] ) );
System.exit( job.waitForCompletion( true ) ? 0 : 1 );
}
}