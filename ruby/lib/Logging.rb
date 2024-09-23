module Log
    def self.log(msg, indents=0, key="LOG")
        print("[" + key + "] " + msg + "\n")
    end
    def self.msg(text, indents=0)
		self.log(text,'LOG')
	end
    
    def self.warning(msg, indents=0)
        self.log(msg,indents,"WARNING")
    end
    
    def self.error(msg, indents=0)
        self.log(msg,indents,"ERROR")
    end
    
    def self.success(msg, indents=0)
        self.log(msg,indents,"SUCCESS")
    end
    
    def self.debug(msg, indents=0)
        self.log(msg,indents,"DEBUG")
    end
    
    def self.start()
        self.log("Script Start")
    end
    
    def self.end()
        self.success("Script End")
    end
end