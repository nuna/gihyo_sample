class HbaseBenchmarkController < ApplicationController
  require 'benchmark'
  require 'stargate'

  def set
    Benchmark.bm do |x|
      x.report('HBase') {
        client = Stargate::Client.new("http://localhost:8080")

        client.create_table('articles', 'data')
        1.upto(10000) do |num|
          client.create_row('articles', num.to_s, Time.now.to_i, [
            {:name => 'data:title', :value => "title_#{num}"},
            {:name => 'data:body', :value => "body_#{num}"}
          ])
        end
      }
    end

    render :text => 'finish'
  end

  def get
    Benchmark.bm do |x|
      x.report('HBase') {
        client = Stargate::Client.new("http://localhost:8080")

        1.upto(10000) do |num|
          row = client.show_row('articles', (1 + rand(10000)).to_s)
        end
      }

      render :text => 'finish'
    end
  end
end
