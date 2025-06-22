-- fileCsv
-- Meta:

name("CSV file");
category(categories.documents);
icon(".csv");

-- Challenges:

challenge.fileCsv.none = {
    type = "none",
};

-- Concepts:

CsvRow = Of.Item.Record.CsvRow();

-- Ops:

op.fileCsv.csvChanged = function (payload, opt, ctx)
    yield(
        op.core.tabular({csv = payload.path}),
        op.core.infer({set = CsvRow})
    );
end

-- Origins:

origin.fileCsv.loc = {
    bid = function (descriptor, score, input)
        local uri = urlParse(descriptor);
        local isFileUri = (uri.isValid and uri.scheme == "file");
        local isHttpUri = (uri.isValid and uri.scheme == "http");
        local isAbsPath = descriptor:find("/") == 1;
        local isCsvExt = descriptor:sub(-3):find("csv") == 1;
        if (isFileUri or isHttpUri or isAbsPath) then
            score:somewhatLikely();
            if (isCsvExt) then
                score:veryLikely();
            else
                score:ratherUnlikely();
            end
        else
            score:veryUnlikely();
        end
        input.path = descriptor;
    end,
    configure = function (input, abort)
        local path = input.path;
        local schemeStart, schemeEnd = path:find("://");
        if (schemeStart) then
            path = path:sub(schemeEnd + 1);
        end
        for part in string.gmatch(path, "[^/]+") do
            input.name = part;
        end
    end,
    start = function (ctx)
        ctx.fs:watch(ctx.input.path, op.fileCsv.csvChanged());
    end,
    stop = function (ctx)
        ctx.fs:unwatch(ctx.input.path);
    end,
    parameters = {
        path = P:path(),
    },
};
