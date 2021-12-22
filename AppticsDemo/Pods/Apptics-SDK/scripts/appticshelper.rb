
require 'xcodeproj'
require 'fileutils'
require "net/http"
require "uri"
require "json"

class AppticsModerator
  
  $projectName # project name
  $targetName # target name
  $fileName = "AppticsExtension" #
  $apiClassName = "APIExtension" #
  $prefix="AP"
  $AppticsGroupName="Apptics"
  
  def self.add_group_to_project(main_group)
    name_of_generated_folder=$AppticsGroupName
    generated_group = main_group[name_of_generated_folder]
    unless generated_group
      generated_group = main_group.new_group(name_of_generated_folder)
    end
    return generated_group
  end
  
#  def self.add_files_to_target(target, file_references)
#    name_of_generated_folder=$AppticsGroupName
#    generated_group = main_group[name_of_generated_folder]
#    unless generated_group
#      generated_group = main_group.new_group(name_of_generated_folder)
#    end
#    return generated_group
#  end
  
  def self.main(projectName, selectedTargetName, targetgroup, projectRootDir, lang, prefix)
    $prefix=prefix
    $fileName=$prefix+$fileName
    $apiClassName=$prefix+$apiClassName
    data_hash = JSON.parse(File.read('/tmp/AppticsMeta.json'))
    
    if data_hash == nil || data_hash["result"] != "success"
      puts "Response : #{data_hash}"
      return false
      else
      data_hash=data_hash["data"]
    end    
    
    event_hash = data_hash["event"]
    api_hash = data_hash["api"]
        
    file_ext="h,m"
    if lang == "objc"
      objch_fc = "#import <Foundation/Foundation.h>\n"
      objch_fc.concat("#if __has_include(<Apptics/Apptics-umbrella.h>)\n")
      objch_fc.concat("@import Apptics;\n")
      objch_fc.concat("#elif __has_include(<Apptics/APEventsEnum.h>)\n")
      objch_fc.concat("#import <Apptics/APEventsEnum.h>\n")
      objch_fc.concat("#import <Apptics/Apptics.h>\n")
      objch_fc.concat("#import <Apptics/Analytics.h>\n")
      objch_fc.concat("#import <Apptics/APBundle.h>\n")
      objch_fc.concat("#else\n")
      objch_fc.concat("#import \"APEventsEnum.h\"\n")
      objch_fc.concat("#import \"Apptics.h\"\n")
      objch_fc.concat("#import \"Analytics.h\"\n")
      objch_fc.concat("#import \"APBundle.h\"\n")
      objch_fc.concat("#endif\n")
      
      objch_fc.concat("typedef enum {\n")
      objch_fc.concat("\tAPEventTypeNone")
      
      objcm_fc = "#import \"#{$fileName}.h\"\n\n"
      
      objcm_fc_m0="@implementation Apptics (Extension)\n\n"
      
      objcm_fc_m1=""
            
      objcm_fc_m2=""
      objcm_fc_m01 = "+ (NSString*) groupID :(APEventType) type;{\n"
      
      objcm_fc_m01.concat("\tNSString *groupId;\n\n")
      objcm_fc_m01.concat("\tswitch (type) {\n")
      
      if event_hash != nil
      objcm_fc_m0.concat("+ (void) setCustomEventsProtocol;{\n")
      objcm_fc_m0.concat("\t[APBundle getInstance].eventsProtocolClass=#{$fileName}.class;\n}\n\n")
      end
      
      if api_hash != nil
      objcm_fc_m0.concat("+ (void) setApiTrackingProtocol;{\n")
      objcm_fc_m0.concat("\t[APBundle getInstance].apiProtocolClass=#{$apiClassName}.class;\n}\n\n")
      end      
      
      if event_hash != nil
          objcm_fc_m1="@implementation #{$fileName} : NSObject\n\n"
          objcm_fc_m1.concat("+ (APPrivateObject *)formatTypeToPrivateObject:(NSString*)group event : (NSString*) event {\n\n")
          
          objcm_fc_m2.concat("+ (APPrivateObject *)formatTypeToPrivateObjectFromEventId:(NSString*)eventId{\n\n\t")
          
          objcm_fc_m0.concat("+ (NSString*) eventID :(APEventType) type;{\n")
          objcm_fc_m0.concat("\tNSString *eventId;\n\n")
          objcm_fc_m0.concat("\tswitch (type) {\n")
          flag2 = false
          
          objcm_fc_m1.concat("\tNSString* event_str=[NSString stringWithFormat:@\"%@_%@\",group, event];\n\n\t")
          event_hash.map do | group, groupInfo|
              
            group = group.strip.gsub(/[^0-9A-Za-z]/, '_')
            groupID = groupInfo["groupid"]
            events = groupInfo["event"]
            flag2 = true
            events.map do | name, id |
                name = name.strip.gsub(/[^0-9A-Za-z]/, '_')
                
                objch_fc.concat(",\n\n\tAPEventType_#{group}_#{name}")
                objcm_fc_m0.concat("\t\tcase APEventType_#{group}_#{name}:\n")
                objcm_fc_m0.concat("\t\t\teventId=@\"#{id}\";\n")
                objcm_fc_m0.concat("\t\t\tbreak;\n")
                
                objcm_fc_m01.concat("\t\tcase APEventType_#{group}_#{name}:\n")
                objcm_fc_m01.concat("\t\t\tgroupId=@\"#{groupID}\";\n")
                objcm_fc_m01.concat("\t\t\tbreak;\n")
                
                objcm_fc_m1.concat("if ([event_str isEqualToString:@\"#{group}_#{name}\"]){\n")
                objcm_fc_m1.concat("\t\treturn [[APPrivateObject alloc] initWith:@\"#{id}\" andGroupId:@\"#{groupID}\"];\n")
                objcm_fc_m1.concat("\t}else ")
                
                objcm_fc_m2.concat("if ([eventId isEqualToString:@\"#{id}\"]){\n")
                objcm_fc_m2.concat("\t\treturn [[APPrivateObject alloc] initWith:@\"#{group}\" event:@\"#{name}\"];\n")
                objcm_fc_m2.concat("\t}else ")
            end
            
          end
      
      objcm_fc_m0.concat("\t\tcase APEventTypeNone:\n")
      objcm_fc_m0.concat("\t\t\tbreak;\n")
      objcm_fc_m0.concat("\t\tdefault:\n")
      objcm_fc_m0.concat("\t\t\tbreak;\n")
      objcm_fc_m0.concat("\t}\n")
      objcm_fc_m0.concat("\treturn eventId;\n}\n\n")
      
      objcm_fc_m01.concat("\t\tcase APEventTypeNone:\n")
      objcm_fc_m01.concat("\t\t\tbreak;\n")
      objcm_fc_m01.concat("\t\tdefault:\n")
      objcm_fc_m01.concat("\t\t\tbreak;\n")
      objcm_fc_m01.concat("\t}\n")
      objcm_fc_m01.concat("\treturn groupId;\n}\n\n")
      objcm_fc_m0.concat(objcm_fc_m01)
      
      objcm_fc_m0.concat("+ (void) trackEventWithType:(APEventType) type;{\n")
      objcm_fc_m0.concat("\t[self trackEventWithType:type andProperties:nil];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;{\n")
      objcm_fc_m0.concat("\tNSString *eventID = [self eventID:type];\n")
      objcm_fc_m0.concat("\tNSString *groupID = [self groupID:type];\n")
      objcm_fc_m0.concat("\t[[Analytics getInstance] trackEvent:eventID groupId : groupID andProperties:props isTimed:false];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) startTimedEventWithType:(APEventType) type;{\n")
      objcm_fc_m0.concat("\t[self startTimedEventWithType:type andProperties:nil];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;{\n")
      objcm_fc_m0.concat("\tNSString *eventID = [self eventID:type];\n")
      objcm_fc_m0.concat("\tNSString *groupID = [self groupID:type];\n")
      objcm_fc_m0.concat("\t[[Analytics getInstance] trackEvent:eventID groupId : groupID andProperties:props isTimed:true];\n}\n\n")
      
      objcm_fc_m0.concat("+ (void) endTimedEventWithType:(APEventType) type;{\n")
      objcm_fc_m0.concat("\tNSString *eventID = [self eventID:type];\n")
      objcm_fc_m0.concat("\t[[Analytics getInstance] endTimedEvent:eventID];\n}\n\n")
      
      if flag2 == true
          objcm_fc_m1.concat("\t{\n")
          objcm_fc_m1.concat("\treturn nil;\n")
          objcm_fc_m1.concat("\t}\n")
          
          objcm_fc_m2.concat("\t{\n")
          objcm_fc_m2.concat("\treturn nil;\n")
          objcm_fc_m2.concat("\t}\n")
          else
          objcm_fc_m1.concat("\treturn nil;\n")
          objcm_fc_m2.concat("\treturn nil;\n")
      end
      
      objcm_fc_m1.concat("}\n\n")
      objcm_fc_m2.concat("}\n\n")
      
      objcm_fc_m1.concat(objcm_fc_m2)
      objcm_fc_m1.concat("@end\n\n")
      end
      
      objcm_fc_m0.concat("@end\n\n")
                  
      objcm_fc.concat(objcm_fc_m0)
      
      objcm_fc.concat(objcm_fc_m1)                  
      
      objch_fc.concat("\n\n}APEventType;\n\n")
      
      objch_fc.concat("@interface Apptics(Extension)\n\n")
      
      if event_hash != nil
          objch_fc.concat("+ (void) setCustomEventsProtocol;\n\n")
          
          objch_fc.concat("+ (NSString*_Nullable) eventID :(APEventType) type;\n\n")
          
          objch_fc.concat("+ (void) trackEventWithType:(APEventType) type;\n\n")
          
          objch_fc.concat("+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;\n\n")
          
          objch_fc.concat("+ (void) startTimedEventWithType:(APEventType) type;\n\n")
          
          objch_fc.concat("+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;\n\n")
          
          objch_fc.concat("+ (void) endTimedEventWithType:(APEventType) type;\n\n")
      end
      
      if api_hash != nil
          objch_fc.concat("+ (void) setApiTrackingProtocol;\n\n")
      end
            
      objch_fc.concat("@end\n\n")
      
      if event_hash != nil
      objch_fc.concat("@interface #{$fileName} : NSObject <APEventsProtocol>\n")
      objch_fc.concat("@end\n\n")
      end
      
      if api_hash != nil
          
          objch_fc.concat("@interface #{$apiClassName} : NSObject <APAPIProtocol>\n")
          objch_fc.concat("@end\n")
          
          objcm_ap="@implementation #{$apiClassName} : NSObject\n\n"""
          objcm_ap.concat("+(BOOL) isMatchString : (NSString* ) source withString : (NSString*) pattern{\n")
          objcm_ap.concat("\tNSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];\n")
          objcm_ap.concat("\tlong n = [regex numberOfMatchesInString:source options:0 range:NSMakeRange(0, [source length])];\n")
          objcm_ap.concat("\treturn  (n > 0);\n")
          objcm_ap.concat("}\n\n")
          objcm_ap_m0 = "+(NSString*) directMatch : (NSString*) url{\n\n\t"
          objcm_ap_m1 = "+(NSString*) patternMatch : (NSString*) url{\n\n\t"
          
          flag0 = false
          flag1 = false
          
          api_hash.map do | apiInfo|
              id = apiInfo["ID"]
              appID = apiInfo["AppID"]
              validationURL = apiInfo["ValidationURL"]
              type = apiInfo["Type"]
              url = apiInfo["URL"]
              name = apiInfo["Name"]
              isKey = apiInfo["IsKey"]
              
              if type == 1 || type == 2
                  objcm_ap_m0.concat("if ([url isEqualToString:@\"#{url}\"]){\n")
                  objcm_ap_m0.concat("\t\treturn @\"#{id}\";\n")
                  objcm_ap_m0.concat("\t}else ")
                  flag0 = true
              else
                  objcm_ap_m1.concat("if ([self isMatchString:url withString:@\"#{url}\"]){\n")
                  objcm_ap_m1.concat("\t\treturn @\"#{id}\";\n")
                  objcm_ap_m1.concat("\t}else ")
                  flag1 = true
              end
              
          end
                 
         if flag0 == true
             objcm_ap_m0.concat("\t{\n")
             objcm_ap_m0.concat("\t\treturn nil;\n")
             objcm_ap_m0.concat("\t}\n\n")
             else
             objcm_ap_m0.concat("\treturn nil;\n")
         end
         
         objcm_ap_m0.concat("}\n\n")
         
         if flag1 == true
             objcm_ap_m1.concat("\t{\n")
             objcm_ap_m1.concat("\t\treturn nil;\n")
             objcm_ap_m1.concat("\t}\n\n")
             else
             objcm_ap_m1.concat("\treturn nil;\n")
         end
         objcm_ap_m1.concat("}\n\n")
         
         objcm_ap.concat(objcm_ap_m0)
         objcm_ap.concat(objcm_ap_m1)
         
         objcm_ap.concat("@end\n")
         objcm_fc.concat(objcm_ap)
      end
                  
      out_file = File.new("/tmp/#{$fileName}.h", "w")
      out_file.puts(objch_fc)
      out_file.close
      
      out_file = File.new("/tmp/#{$fileName}.m", "w")
      out_file.puts(objcm_fc)
      out_file.close
      else
      file_ext="swift"
      swiftc_fc = "#if canImport(Apptics)\n\timport Apptics\n#endif\n\n"
      
      swiftc_fc_enum=""
      
      swiftc_fc_ap_ext="extension Apptics\n{\n"
      
      if event_hash != nil
      swiftc_fc_ap_ext.concat("\t@objc class func setCustomEventsProtocol() {\n")
      swiftc_fc_ap_ext.concat("\t\tAPBundle.getInstance()?.eventsProtocolClass=#{$fileName}.self\n")
      swiftc_fc_ap_ext.concat("\t}\n")
      end
      
      if api_hash != nil
      swiftc_fc_ap_ext.concat("\n\t@objc class func setApiTrackingProtocol() {\n")
      swiftc_fc_ap_ext.concat("\t\tAPBundle.getInstance()?.apiProtocolClass=#{$apiClassName}.self\n")
      swiftc_fc_ap_ext.concat("\t}\n")
      end
      
      swiftc_fc_cc=""
      
      if event_hash != nil
          
          swiftc_fc_ap_ext_f0="\n\t@objc class func eventID(forType type : APEventType) -> String?{\n"
          swiftc_fc_ap_ext_f01="\t@objc class func groupID(forType type : APEventType) -> String?{\n"
          swiftc_fc_ap_ext_f1="\t@objc class func trackEvent(withType type : APEventType, andProperties : [String : Any]?) {\n"
          swiftc_fc_ap_ext_f0.concat("\n\t\tvar eventID : String?\n")
          swiftc_fc_ap_ext_f0.concat("\t\tswitch (type) {\n")
          swiftc_fc_ap_ext_f01.concat("\n\t\tvar groupID : String?\n")
          swiftc_fc_ap_ext_f01.concat("\t\tswitch (type) {\n")
          
          swiftc_fc_ap_ext_f2="\t@objc class func trackEvent(withType type : APEventType) {\n"
          swiftc_fc_ap_ext_f2.concat("\t\tself.trackEvent(withType: type, andProperties: nil)\n")
          
          swiftc_fc_ap_ext_f2.concat("\t}\n\n")
          
          swiftc_fc_cc.concat("class #{$fileName}: NSObject, APEventsProtocol {\n\n")
          swiftc_fc_cc.concat("\tclass func formatType(toPrivateObject group: String, event: String) -> APPrivateObject? {\n\n")
                
          swiftc_fc_m1="\tclass func formatTypeToPrivateObject(fromEventId eventId: String) -> APPrivateObject?{\n\n\t\t"
          flag2 = false
          
          swiftc_fc_enum.concat("@objc enum APEventType : Int {\n")
          swiftc_fc_cc.concat("\t\tlet event_str = \"\\(group)_\\(event)\"\n\n\t\t")
          event_hash.map do | group, groupInfo|
            group = group.strip.gsub(/[^0-9A-Za-z]/, '_')
            groupID = groupInfo["groupid"]
            events = groupInfo["event"]
            flag2 = true
              events.map do | name, id|
                name = name.strip.gsub(/[^0-9A-Za-z]/, '_')
                
                swiftc_fc_enum.concat("    case _#{group}_#{name}\n")
                
                swiftc_fc_ap_ext_f0.concat("\t\tcase ._#{group}_#{name}:\n")
                swiftc_fc_ap_ext_f0.concat("\t\t\teventID=\"#{id}\"\n")
                swiftc_fc_ap_ext_f0.concat("\t\t\tbreak\n")
                
                swiftc_fc_ap_ext_f01.concat("\t\tcase ._#{group}_#{name}:\n")
                swiftc_fc_ap_ext_f01.concat("\t\t\tgroupID=\"#{id}\"\n")
                swiftc_fc_ap_ext_f01.concat("\t\t\tbreak\n")
                
                swiftc_fc_cc.concat("if (event_str == \"#{group}_#{name}\") {\n")
                swiftc_fc_cc.concat("\t\t\treturn APPrivateObject(\"#{id}\", andGroupId:\"#{groupID}\")\n")
                swiftc_fc_cc.concat("\t\t}else ")
                
                swiftc_fc_m1.concat("if (eventId == \"#{id}\") {\n")
                swiftc_fc_m1.concat("\t\t\treturn APPrivateObject(\"#{group}\", event: \"#{name}\")\n")
                swiftc_fc_m1.concat("\t\t}else ")
              end
    #        end
            
          end
          swiftc_fc_enum.concat("\t\tcase None\n")
          swiftc_fc_enum.concat("}\n\n")
                  
      swiftc_fc_ap_ext_f0.concat("\t\tcase .None:\n")
      swiftc_fc_ap_ext_f0.concat("\t\t\tbreak\n")
      swiftc_fc_ap_ext_f0.concat("\t\t\tdefault: break\n")
      swiftc_fc_ap_ext_f0.concat("\t\t}\n")
      swiftc_fc_ap_ext_f0.concat("\t\treturn eventID\n\n")
      swiftc_fc_ap_ext_f0.concat("\t}\n\n")
      
      swiftc_fc_ap_ext_f01.concat("\t\tcase .None:\n")
      swiftc_fc_ap_ext_f01.concat("\t\t\tbreak\n")
      swiftc_fc_ap_ext_f01.concat("\t\t\tdefault: break\n")
      swiftc_fc_ap_ext_f01.concat("\t\t}\n")
      swiftc_fc_ap_ext_f01.concat("\t\treturn groupID\n\n")
      swiftc_fc_ap_ext_f01.concat("\t}\n\n")
      
      swiftc_fc_ap_ext_f1.concat("\t\tif let eventID = self.eventID(forType: type){\n")
      swiftc_fc_ap_ext_f1.concat("\t\t\tlet groupID = self.groupID(forType: type)\n")
      swiftc_fc_ap_ext_f1.concat("\t\tAnalytics.getInstance().trackEvent(eventID, groupId: groupID, andProperties: andProperties, isTimed: false)\n")
      swiftc_fc_ap_ext_f1.concat("\t\t}\n")
      swiftc_fc_ap_ext_f1.concat("\t}\n\n")
      
      swiftc_fc.concat(swiftc_fc_enum)
      
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f0)
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f01)
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f1)
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f2)
      
      swiftc_fc_ap_ext_f3="\t@objc class func startTimedEvent(withType type : APEventType, andProperties : [String : Any]?){\n"
      swiftc_fc_ap_ext_f3.concat("\t\tif let eventID = self.eventID(forType: type){\n")
      swiftc_fc_ap_ext_f3.concat("\t\t\tlet groupID = self.groupID(forType: type)\n")
      swiftc_fc_ap_ext_f3.concat("\t\tAnalytics.getInstance().startTimedEvent(eventID, groupId: groupID, andProperties: andProperties)\n")
      swiftc_fc_ap_ext_f3.concat("\t\t}\n")
      swiftc_fc_ap_ext_f3.concat("\t}\n\n")
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f3)
      
      
      swiftc_fc_ap_ext_f4="\t@objc class func endTimedEvent(withType type : APEventType){\n"
      swiftc_fc_ap_ext_f4.concat("\t\tif let eventID = self.eventID(forType: type){\n")
      swiftc_fc_ap_ext_f4.concat("\t\tAnalytics.getInstance().endTimedEvent(eventID)\n")
      swiftc_fc_ap_ext_f4.concat("\t\t}\n")
      swiftc_fc_ap_ext_f4.concat("\t}\n")
      swiftc_fc_ap_ext.concat(swiftc_fc_ap_ext_f4)
      
      
      if flag2 == true
          swiftc_fc_m1.concat("{\n")
          swiftc_fc_m1.concat("\t\t\treturn nil;\n")
          swiftc_fc_m1.concat("\t\t}\n")
          
          swiftc_fc_cc.concat("{\n")
          swiftc_fc_cc.concat("\t\t\treturn nil;\n")
          swiftc_fc_cc.concat("\t\t}\n")
          else
          swiftc_fc_m1.concat("return nil;\n")
          swiftc_fc_cc.concat("\t\treturn nil;\n")
      end
      
      swiftc_fc_m1.concat("\t}\n\n")
      swiftc_fc_cc.concat("\t}\n\n")
      
      swiftc_fc_cc.concat(swiftc_fc_m1)
      swiftc_fc_cc.concat("}\n\n")
      
      end
      
      swiftc_fc_ap_ext.concat("\n}\n\n")
      swiftc_fc.concat(swiftc_fc_ap_ext)
      
      swiftc_fc.concat(swiftc_fc_cc)
      
      
      
      if api_hash != nil
          swiftc_fc_api_ext="class #{$apiClassName}: NSObject, APAPIProtocol {\n\n"
          swiftc_fc_api_ext.concat("\tclass func isMatch(_ source: String?, with pattern: String?) -> Bool {\n")
          swiftc_fc_api_ext.concat("\t\tvar regex: NSRegularExpression? = nil\n")
          swiftc_fc_api_ext.concat("\t\tdo {\n")
          swiftc_fc_api_ext.concat("\t\t\tregex = try NSRegularExpression(pattern: pattern ?? \"\", options: [])\n")
          swiftc_fc_api_ext.concat("\t\t} catch {\n")
          swiftc_fc_api_ext.concat("\t\t}\n")
          swiftc_fc_api_ext.concat("\t\tlet n = regex?.numberOfMatches(in: source ?? \"\", options: [], range: NSRange(location: 0, length: source?.count ?? 0)) ?? 0\n")
          swiftc_fc_api_ext.concat("\t\treturn n > 0\n")
          swiftc_fc_api_ext.concat("\t}\n\n")
          
          swiftc_fc_api_ext_f1="\tclass func directMatch(_ url: String) -> String? {\n\t\t"

          swiftc_fc_api_ext_f2="\tclass func patternMatch(_ url: String) -> String? {\n\t\t"
          
          
          flag0 = false
          flag1 = false
          
          api_hash.map do | apiInfo|
              id = apiInfo["ID"]
              appID = apiInfo["AppID"]
              validationURL = apiInfo["ValidationURL"]
              type = apiInfo["Type"]
              url = apiInfo["URL"]
              name = apiInfo["Name"]
              isKey = apiInfo["IsKey"]
              
              if type == 1 || type == 2
                swiftc_fc_api_ext_f1.concat("if url == \"#{url}\" {\n")
                swiftc_fc_api_ext_f1.concat("\t\t\treturn \"#{id}\"\n")
                swiftc_fc_api_ext_f1.concat("\t\t}else ")
                flag0 = true
              else
                swiftc_fc_api_ext_f2.concat("if self.isMatch(url, with:\"#{url}\") == true{\n")
                swiftc_fc_api_ext_f2.concat("\t\t\treturn \"#{id}\"\n")
                swiftc_fc_api_ext_f2.concat("\t\t}else ")
                flag1 = true
              end
              
          end
      
      if flag0 == true
        swiftc_fc_api_ext_f1.concat("\t\t{\n")
        swiftc_fc_api_ext_f1.concat("\t\t\treturn nil\n\t\t}\n")
      else
        swiftc_fc_api_ext_f1.concat("\treturn nil\n")
      end
      swiftc_fc_api_ext_f1.concat("\t}\n\n")
      
      if flag1 == true
        swiftc_fc_api_ext_f2.concat("\t\t{\n")
        swiftc_fc_api_ext_f2.concat("\t\t\treturn nil\n\t\t}\n")
      else
        swiftc_fc_api_ext_f2.concat("\treturn nil\n")
      end
      swiftc_fc_api_ext_f2.concat("\t}\n\n")
           
      swiftc_fc_api_ext.concat(swiftc_fc_api_ext_f1)
      swiftc_fc_api_ext.concat(swiftc_fc_api_ext_f2)
                                            
      swiftc_fc_api_ext.concat("}\n\n")
      swiftc_fc.concat(swiftc_fc_api_ext)
      end
            
      out_file = File.new("/tmp/#{$fileName}.swift", "w")
      out_file.puts(swiftc_fc)
      out_file.close
      
    end
    
#    out_file = File.new("/tmp/#{$AppticsGroupName}.json", "w")
#    out_file.close
    
    targetName=selectedTargetName
    destinationFileName=$fileName
    main_project_path = File.expand_path(projectName)
    project = Xcodeproj::Project.open(main_project_path)
    
    
    
    #project.targets.each do |target|
      
      #if target.name == targetName
        
        puts 'Project root : '+projectRootDir+'\n'
        
        #          target_group = project.main_group.find_subpath(targetName)
        #          if target_group == nil
        #            target_group = project.main_group
        #          end
        
        target_group = project.main_group
        if target_group != nil
          if targetgroup == ""              
              apptics_group=add_group_to_project(target_group)
              project_path = projectRootDir
          else
            apptics_group=add_group_to_project(target_group[targetgroup])
            project_path = projectRootDir+"/"+targetgroup
          end
          
          file_ref = project_path
          files = []
          tmpDir = Dir["/tmp/#{$fileName}.{#{file_ext}}"]
          
          tmpDir.each do | filename|
            basename = File.basename(filename)
            file_ref = project_path + "/" + basename
            FileUtils.cp(filename, project_path, :verbose => true)
                                   
            if apptics_group.find_subpath(basename).nil?
              files.append(apptics_group.new_file(file_ref))
              puts 'Created file "'+filename+'" in "'+apptics_group.name+'"\n'
              else              
              files.append(apptics_group.find_subpath(basename))
              puts '\nUpdated file "'+filename+'" in "'+apptics_group.name+'"\n'
            end
                        
          end
          
          project.targets.each do |target|
            if !target.test_target_type?
              if target.name == targetName
                target.add_file_references(files)
              end
            end
          end
          
#          project_file_name_proj = projectName
        end
        
        project.save(main_project_path)
        puts "Saving project "+main_project_path
        
      #end
    #end
    
  end
  
end

class AppticsBot

  def self.main(filePath)
    
    data_hash = JSON.parse(File.read(filePath))
    
    data_hash = data_hash["data"]
    
    if data_hash == nil
      puts "Invalid entries found for AppticsMeta"
      return false
    end
       
    puts "export appversionid=#{data_hash['appversionid']}"
    puts "export appreleaseversionid=#{data_hash['appreleaseversionid']}"
    puts "export aaid=#{data_hash['aaid']}"
    puts "export apid=#{data_hash['apid']}"
    puts "export mapid=#{data_hash['mapid']}"
    puts "export rsakey=#{data_hash['rsakey']}"
    puts "export platformid=#{data_hash['platformid']}"
    
  end
  
end

class AppticsUploader

    def self.main(filepath, urlstring, token)
      @filepath = filepath
      @urlstring = urlstring
      @token = token
      upload()
    end
    
    def self.valid_json?(string)
      !!JSON.parse(string)
    rescue JSON::ParserError
      false
    end

    def self.upload()
        url = URI.parse(@urlstring)
        File.open(@filepath) do |zip|
          req = Net::HTTP::Post.new(url)
          form_data = [['dsymfile', zip]]
          req.set_form form_data, 'multipart/form-data'
          req['zak']=@token
          res = Net::HTTP.start(url.host, url.port, use_ssl: true, open_timeout:60, read_timeout: 300) do |http|
          http.request(req)
          end
          
        # Status
        puts res.code       # => '200'
        puts res.class.name # => 'HTTPOK'

        # Body
        if valid_json?(res.body)
        data_hash = JSON.parse(res.body)
        puts "dSYM upload status : #{data_hash['result']}"
        if data_hash["result"] == "success"
              puts "data : #{data_hash['data']}"
              else
              puts "error_message : #{data_hash['error_message']}"
        end
        else
          puts res.body
        end
        end
    end
end
