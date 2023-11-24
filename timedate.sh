# TZ time date
ENV TZ=Asia/Jakarta

# symlink localtimezone
#ln -snf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && echo Asia/Jakarta > /etc/timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#install tzdata
RUN apk add --no-cache tzdata
