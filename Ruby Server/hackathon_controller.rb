class HackathonController < ApplicationController

  def index
    puts aap
    render :json =>  "asdadasd"

  end

  def alexa
    en_q = EasyTranslate.translate(params[:q], :to => :english, :from => :dutch, :key => ENV["GOOGLE_API_KEY"])
    ec2 = Fog::Compute.new provider: 'AWS', region: 'eu-central-1', aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    instance = ec2.servers.get('i-0b8eb4e9b23316fdb')
    instance.wait_for { ready? }
    instance.username = "ubuntu"
    instance.private_key = ENV["SSH-KEY"]
    puts instance.ssh('rm response.*')
    puts instance.public_ip_address + " starts script"
    puts instance.ssh('./alexa.sh "' + en_q + '"')
    x = ""
    while(1)
      sleep(0.1)
      puts "-----------"
      puts instance.ssh('cat response.json | grep "transcript"')
      if instance.ssh('cat response.json | grep "transcript"')
        x = instance.ssh('cat response.json | grep "transcript"')
        break;
      end
    end
    x =  x[0].stdout.gsub("\n"," ").strip.gsub("transcript", "").delete('"').delete(':').strip.gsub("  ", "").strip
    # aap =  instance.ssh('cat response.json | grep "transcript"')
    puts x
    puts nl_a = EasyTranslate.translate(x, :from => :english, :to => :dutch, :key => ENV["GOOGLE_API_KEY"])
    content = Alexa.create(content: nl_a, lang: "nl")
    render :json =>  nl_a
  end

  def alexa2
    render :json => Alexa.where(lang: "nl").last.content
  end

  def alexaengels
    en_q = params[:q]
    ec2 = Fog::Compute.new provider: 'AWS', region: 'eu-central-1', aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    instance = ec2.servers.get('i-0b8eb4e9b23316fdb')
    instance.wait_for { ready? }
    instance.username = "ubuntu"
    instance.private_key = ENV["SSH-KEY"]
    puts instance.ssh('rm response.*')
    puts instance.public_ip_address + " starts script"
    puts instance.ssh('./alexa.sh "' + en_q + '"')
    x = ""
    while(1)
      sleep(0.1)
      puts "-----------"
      puts instance.ssh('cat response.json | grep "transcript"')
      if instance.ssh('cat response.json | grep "transcript"')
        x = instance.ssh('cat response.json | grep "transcript"')
        break;
      end
    end
    x =  x[0].stdout.gsub("\n"," ").strip.gsub("transcript", "").delete('"').delete(':').strip.gsub("  ", "").strip
    # aap =  instance.ssh('cat response.json | grep "transcript"')
    puts x
    # puts nl_a = EasyTranslate.translate(x, :from => :english, :to => :dutch, :key => ENV["GOOGLE_API_KEY"])
    content = Alexa.create(content: x, lang: "en")
    render :json =>  x
  end

  def alexaengels2
    render :json => Alexa.where(lang: "en").last.content
  end

end
